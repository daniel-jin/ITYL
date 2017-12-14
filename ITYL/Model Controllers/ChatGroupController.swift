//
//  ChatGroupController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/24/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

class ChatGroupController {
    
    // Singleton for model controller
    static let shared = ChatGroupController()
    
    // CloudKit Manager instance
    private let cloudKitManager = CloudKitManager()
    
    // MARK: - Properties
    // Model object array
    var chatGroups: [ChatGroup] {
        
        // Fetch chatgroups from Core Data
        let request: NSFetchRequest<ChatGroup> = ChatGroup.fetchRequest()
        
        //request.sortDescriptors = [NSSortDescriptor(key: "deliverTime", ascending: false)]
        
        // Perform fetch - handle Errors
        do {
            let results = try CoreDataStack.context.fetch(request)
            
            
            /*
            let sortedResults = results.sorted(by:  { (group1, group2) -> Bool in
                
                guard let group1Messages = group1.messages?.array as? [Message],
                    let group2Messages = group2.messages?.array as? [Message] else { return false }
                
                guard let group1Message = group1Messages.sorted(by: { $0.deliverTime!.timeIntervalSince1970 > $1.deliverTime!.timeIntervalSince1970 }).first,
                    let group2Message = group2Messages.sorted(by: { $0.deliverTime!.timeIntervalSince1970 > $1.deliverTime!.timeIntervalSince1970 }).first else { return false }
                
                if group1Message.deliverTime!.timeIntervalSince1970 > group2Message.deliverTime!.timeIntervalSince1970 {
                    return true
                } else {
                    return false
                    
                }
            })
             */
            
            return results
            
        } catch {
            NSLog("There was an error configuring the fetched results. \(error.localizedDescription)")
            return []
        }
        
        
        
    }
    
    init() {
        
        // Check/fetch new chatgroups from CloudKit
        refreshData()
    }
    
    
    // MARK: - CRUD Functions
    // Create
    func createChatGroupWith(name: String, addUser: User, completion: @escaping (_ success: Bool, _ chatGroup: ChatGroup?) -> Void) {
        
        // Check for current user
        guard let currentUser = UserController.shared.currentUser else {
            NSLog("Error fetching current user.")
            completion(false, nil)
            return
        }
        
        // Create a chatGroup with the current user as the initial member
        let chatGroup = ChatGroup(name: name, users: [currentUser, addUser])
        
        // Save to Core Data first
        self.saveToPersistantStore()
        
        guard let chatGroupRecord = CKRecord(chatGroup: chatGroup) else {
            completion(false, nil)
            return
        }
        
        // Save the CKRecord to CloudKit
        self.cloudKitManager.save(chatGroupRecord) { (error) in
            // Handle error
            if let error = error {
                NSLog(error.localizedDescription)
                completion(false, nil)
                return
            }
            
            // Add to local array
            
            // Modify both users in the chat groups
            let chatGroupRef = CKReference(record: chatGroupRecord, action: .none)
            currentUser.chatGroupsRef.append(chatGroupRef)
            addUser.chatGroupsRef.append(chatGroupRef)
            
            guard let currentUserRecord = CKRecord(user: currentUser),
                let addUserRecord = CKRecord(user: addUser) else {
                    completion(false, nil)
                    return
            }
            
            self.cloudKitManager.modifyRecords([currentUserRecord, addUserRecord], perRecordCompletion: nil, completion: { (records, error) in
                
                if let error = error {
                    NSLog(error.localizedDescription)
                    completion(false, nil)
                    return
                }
                completion(true, chatGroup)
            })
        }
    }
    
    // Helper functions
    func refreshData(completion: @escaping (() -> Void) = {}) {
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // Iterate through the current user's chat group CKReference array and add the chat groups to the current user's local array
        let group = DispatchGroup()
        
        // Check core data so we only fetch chat groups from CK that we need to
        let syncedGroups = chatGroups.filter({$0.recordIDString != "NOT SYNCED YET"})
        
        let referencesToExclude = syncedGroups.map{ CKReference(recordID: CKRecordID(recordName: $0.recordIDString), action: .none) }
        let filteredRefs = currentUser.chatGroupsRef.filter { !referencesToExclude.contains($0) }
        
        // Pull down filtered chat groups from cloudkit, then save to core data
        for CKRef in filteredRefs {
            
            group.enter()
            
            cloudKitManager.fetchRecord(withID: CKRef.recordID, completion: { (CGRecord, error) in
                
                if let error = error {
                    NSLog(error.localizedDescription)
                    group.leave()
                    return
                }
                
                guard let CGRecord = CGRecord,
                    let users = CGRecord[Keys.chatGroupMembersKey] as? [CKReference] else {
                        group.leave()
                        return
                }
                
                var chatGroupUsers = [User]()
                
                let group2 = DispatchGroup()
                
                for CKRef in users {
                    
                    group2.enter()
                    
                    CloudKitManager().fetchRecord(withID: CKRef.recordID, completion: { (record, error) in
                        if let error = error {
                            NSLog("Error fetching user with provided Record ID: \(error.localizedDescription)")
                            group2.leave()
                            return
                        }
                        
                        if let record = record {
                            guard let user = User(cloudKitRecord: record) else {
                                group2.leave()
                                return
                            }
                            chatGroupUsers.append(user)
                            group2.leave()
                        }
                    })
                }
                
                group2.notify(queue: .main, execute: {
                    let _ = ChatGroup(cloudKitRecord: CGRecord, users: chatGroupUsers)
                    group.leave()
                })
                
            })
        }
        
        
        
        group.notify(queue: DispatchQueue.main) {
            NotificationCenter.default.post(name: Keys.ChatGroupsArrayChangeNotification, object: nil)
            self.saveToPersistantStore()
            completion()
        }
    }
}
