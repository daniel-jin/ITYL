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
    
    // MARK: - Properties
    // Model object array
    var messages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Keys.MessagesArrayChangeNotification, object: nil)
            }
        }
    }
    
    // MARK: - CRUD Functions
    // Create
    func createMessageWith(messageText: String, sendingUser: CKReference, chatGroup: CKReference, completion: @escaping (_ success: Bool) -> Void) {
        
        // Check for current user
        guard let currentUser = UserController.shared.currentUser else {
            NSLog("Error fetching current user.")
            completion(false)
            return
        }
        
        //TODO: - Go over with Spencer on none vs deleteSelf (when a chat group is deleted, should the messages stay? who gets to delete the group?)
        let chatGroupRef = CKReference(recordID: CKRecordID, action: .deleteSelf)
        
        let message = Message(message: messageText, sendingUser: currentUser, chatGroup: <#T##CKReference#>)
        
    }
    
}
