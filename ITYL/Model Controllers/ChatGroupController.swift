//
//  ChatGroupController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/24/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

class ChatGroupController {
    
    // Singleton for model controller
    static let shared = ChatGroupController()
    
    // CloudKit Manager instance
    private let cloudKitManager = CloudKitManager()
    
    // MARK: - Properties
    // Model object array
    var chatGroups: [ChatGroup] {
        
        guard let currentUser = UserController.shared.currentUser else { return [] }
        
        // Iterate through the current user's chat group CKReference array and add the chat groups to the current user's local array
        for CKRef in currentUser.chatGroupsRef {
            
            cloudKitManager.fetchRecord(withID: CKRef.recordID, completion: { (CGRecord, error) in
                
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
                
                guard let CGRecord = CGRecord,
                    let chatGroup = ChatGroup(cloudKitRecord: CGRecord) else { return }
                
                chatGroups.append(chatGroup)
            })
        }
        
        
        
//        didSet {
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: Keys.ChatGroupsArrayChangeNotification, object: nil)
//            }
//        }
    }
    
    // MARK: - CRUD Functions
    // Create
    func createChatGroupWith(name: String, addUser: User, completion: @escaping (_ success: Bool) -> Void) {
        
        // Check for current user
        guard let currentUser = UserController.shared.currentUser else {
            NSLog("Error fetching current user.")
            completion(false)
            return
        }
        
        // Create a chatGroup with the current user as the initial member
        let chatGroup = ChatGroup(chatGroupName: name)
        let chatGroupRecord = CKRecord(chatGroup: chatGroup)
        
        // Save the CKRecord to CloudKit
        self.cloudKitManager.save(chatGroupRecord) { (error) in
            // Handle error
            if let error = error {
                NSLog(error.localizedDescription)
                completion(false)
                return
            }
            // Add to local array
            self.chatGroups.insert(chatGroup, at: 0)
            
            // Modify both users in the chat groups
            let chatGroupRef = CKReference(record: chatGroupRecord, action: .none)
            currentUser.chatGroupsRef.append(chatGroupRef)
            addUser.chatGroupsRef.append(chatGroupRef)
            
            let currentUserRecord = CKRecord(user: currentUser)
            let addUserRecord = CKRecord(user: addUser)
            
            self.cloudKitManager.modifyRecords([currentUserRecord, addUserRecord], perRecordCompletion: nil, completion: { (records, error) in
                
                if let error = error {
                    NSLog(error.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
}
