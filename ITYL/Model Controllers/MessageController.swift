//
//  MessageController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/24/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    // Singleton for model controller
    static let shared = MessageController()
    
    // CloudKit Manager instance
    private let cloudKitManager = CloudKitManager()
    
    // MARK: - CRUD Functions
    // Create
    func createMessageWith(messageText: String, chatGroup: ChatGroup, completion: @escaping (_ success: Bool) -> Void) {
        
        // Check for current user
        guard let currentUser = UserController.shared.currentUser else {
            NSLog("Error fetching current user.")
            completion(false)
            return
        }

        guard let chatGroupCKRecordID = chatGroup.cloudKitRecordID,
            let sendingUserCKRecordID = currentUser.cloudKitRecordID else {
            completion(false)
            return
        }
        
        // CKReference for the chat group and sending (current) user
        let sendingUserRef = CKReference(recordID: sendingUserCKRecordID, action: .deleteSelf)
        let chatGroupRef = CKReference(recordID: chatGroupCKRecordID, action: .deleteSelf)
        
        let message = Message(message: messageText, sendingUser: sendingUserRef, chatGroupRef: chatGroupRef)
        let messageCKRecord = CKRecord(message: message)
        
        // Save to CloudKit
        self.cloudKitManager.save(messageCKRecord) { (error) in
            
            // Handle error
            if let error = error {
                NSLog("Error saving message to CloudKit")
                completion(false)
                return
            }
            
            // Also add the message to the chatGroup that it belongs to
            chatGroup.messages.insert(message, at: 0)
            
            completion(true)
        }
    }
}
