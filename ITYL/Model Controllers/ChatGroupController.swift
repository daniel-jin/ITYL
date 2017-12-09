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
        
        //request.sortDescriptors = [NSSortDescriptor(key: <#T##String?#>, ascending: true)]
        
        // Perform fetch - handle Errors
        do {
            return try CoreDataStack.context.fetch(request)
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
        
        for CKRef in currentUser.chatGroupsRef {
            
            group.enter()
            
            cloudKitManager.fetchRecord(withID: CKRef.recordID, completion: { (CGRecord, error) in
                
                if let error = error {
                    NSLog(error.localizedDescription)
                    group.leave()
                    return
                }
                
                guard let CGRecord = CGRecord,
                    let _ = ChatGroup(cloudKitRecord: CGRecord) else {
                        group.leave()
                        return
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            NotificationCenter.default.post(name: Keys.ChatGroupsArrayChangeNotification, object: nil)
            self.saveToPersistantStore()
            completion()
        }
    }
}
