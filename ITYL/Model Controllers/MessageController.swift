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
    func createMessageWith(messageText: String, chatGroup: ChatGroup, completion: @escaping (_ success: Bool, _ message: Message?) -> Void) {
        
        // Check for current user
        guard let currentUser = UserController.shared.currentUser else {
            NSLog("Error fetching current user.")
            completion(false, nil)
            return
        }

        guard let sendingUserCKRecordID = currentUser.cloudKitRecordID else {
            completion(false, nil)
            return
        }
        
        let chatGroupRecordIDString = chatGroup.recordIDString
        
        let chatGroupRecordID = CKRecordID(recordName: chatGroupRecordIDString)
        
        // CKReference for the chat group and sending (current) user
        let sendingUserRef = CKReference(recordID: sendingUserCKRecordID, action: .deleteSelf)
        let chatGroupRef = CKReference(recordID: chatGroupRecordID, action: .deleteSelf)
        
        let message = Message(message: messageText, sentBy: currentUser, sendingUser: sendingUserRef, chatGroupRef: chatGroupRef, chatGroup: chatGroup)
        
        // Save to Core Data first
        self.saveToPersistantStore()
        
        guard let messageCKRecord = CKRecord(message: message) else {
            completion(false, nil)
            return
        }
        
        // Save to CloudKit
        self.cloudKitManager.save(messageCKRecord) { (error) in
            
            // Handle error
            if error != nil {
                NSLog("Error saving message to CloudKit")
                completion(false, nil)
                return
            }
            
            // Also add the message to the chatGroup that it belongs to
//            chatGroup.messages.insert(message, at: 0)
            
            completion(true, message)
        }
    }
    
    func subscribeToPushNotifications(completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        self.cloudKitManager.subscribeToCreationOfRecords(ofType: Keys.messageRecordType) { (error) in
            if let error = error {
                NSLog("Error saving subscription: \(error)")
            } else {
                NSLog("Subscribed to push notifications for new messages")
            }
            completion(error)
        }
    }
}
