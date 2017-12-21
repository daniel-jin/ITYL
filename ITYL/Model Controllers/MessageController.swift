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
    
    func fetchNewCKMessages(chatGroup: ChatGroup, chatGroupRecordID: CKRecordID) {
        
        cloudKitManager.fetchRecord(withID: chatGroupRecordID) { (record, error) in
            if let error = error {
                NSLog("Error fetching chat group from CloudKit. \(error.localizedDescription)")
                return
            }
            
            if let record = record {
                let chatGroupCKRef = CKReference(record: record, action: .none)
                
                // Check/fetch messages from CloudKit
                
                let chatGroupRefPredicate = NSPredicate(format: "chatGroupRef == %@", chatGroupCKRef)
                
                var predicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [chatGroupRefPredicate])
                
                if let messages = chatGroup.messages,
                    let messagesArray = Array(messages) as? [Message] {
                    
                    //                    let lastMessage = messagesArray.last,
                    //                    let lastMsgTime = lastMessage.deliverTime {
                    //let predicate2 = NSPredicate(format: "deliverTime > %@", lastMsgTime)
                    
                    let msgsToExclude = messagesArray.flatMap{ CKReference(recordID: CKRecordID(recordName: $0.recordIDString), action: .none) }
                    
                    let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [msgsToExclude])
                    
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [chatGroupRefPredicate, predicate2])
                }
                
                // Check/fetch new messages from CloudKit
                
                self.cloudKitManager.fetchRecordsWithType(Keys.messageRecordType, predicate: predicate, recordFetchedBlock: nil) { (ckMessages, error) in
                    if let error = error {
                        NSLog("Error fetching messages from CloudKit: \(error.localizedDescription)")
                        return
                    }
                    
                    let group = DispatchGroup()
                    
                    if let ckMessages = ckMessages {
                        
                        for ckMessage in ckMessages {
                            
                            group.enter()
                            
                            guard let sendingUserRef = ckMessage[Keys.sendingUserRefKey] as? CKReference else {
                                group.leave()
                                return
                            }
                            
                            self.cloudKitManager.fetchRecord(withID: sendingUserRef.recordID, completion: { (record, error) in
                                if let error = error {
                                    NSLog("Error fetching message sender user from CloudKit. \(error.localizedDescription)")
                                    group.leave()
                                    return
                                }
                                
                                if let record = record {
                                    
                                    guard let sentByUser = User(cloudKitRecord: record) else {
                                        group.leave()
                                        return
                                    }
                                    
                                    // Create the message and save to Core Data
                                    _ = Message(cloudKitRecord: ckMessage, chatGroup: chatGroup, sentByUser: sentByUser)
                                    ChatGroupController.shared.saveToPersistantStore()
                                    group.leave()
                                }
                            })
                        }
                    }
                    
                    group.notify(queue: DispatchQueue.main) {
                        
                        guard let sortedMsgs = chatGroup.messages?.mutableCopy() as? NSMutableOrderedSet else { return }
                        let sortDescriptor = NSSortDescriptor(key: "deliverTime", ascending: true)
                        sortedMsgs.sort(using: [sortDescriptor])
                        chatGroup.messages = sortedMsgs
                        UserController.shared.saveToPersistantStore()
                        
                        NotificationCenter.default.post(name: Notifications.reloadChatGroupDetailCVNotification, object: nil)
                        
                    }
                    
                } // Messages have been fetched from CloudKit, saved to CoreData, and sorted by deliverTime
            }
        }
        
    }
    
    func subscribeToPushNotifications(chatGroup: ChatGroup, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        self.cloudKitManager.subscribeToCreationOfRecords(ofType: Keys.messageRecordType, chatGroup: chatGroup) { (error) in
            if let error = error {
                NSLog("Error saving subscription: \(error)")
            } else {
                NSLog("Subscribed to push notifications for new messages")
            }
            completion(error)
        }
    }
}
