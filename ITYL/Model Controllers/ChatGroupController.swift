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
    var chatGroups = [ChatGroup]() {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Keys.ChatGroupsArrayChangeNotification, object: nil)
            }
        }
    }
    
    // MARK: - CRUD Functions
    // Create
    func createChatGroupWith(name: String, completion: @escaping (_ success: Bool) -> Void) {
        
        // Check for current user
        guard let currentUser = UserController.shared.currentUser else {
            NSLog("Error fetching current user.")
            completion(false)
            return
        }
        
        // Create a chatGroup with the current user as the initial member
        let chatGroup = ChatGroup(chatGroupName: name, members: [currentUser], messages: [])
        
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
            completion(true)
        }
    }
}
