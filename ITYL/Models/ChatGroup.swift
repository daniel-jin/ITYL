//
//  ChatGroup.swift
//  ITYL
//
//  Created by Daniel Jin on 10/23/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

class ChatGroup {
    
    // MARK: - Properties
    var chatGroupName: String
    
    var members: [User]

    var messages: [Message] = []
    
    var cloudKitRecordID: CKRecordID?
    
    // MARK: - Initializer
    init(chatGroupName: String, members: [User], messages: [Message]) {
        
        self.chatGroupName = chatGroupName
        self.members = members
        self.messages = messages
    }
}
