//
//  ChatGroup.swift
//  ITYL
//
//  Created by Daniel Jin on 10/23/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

struct ChatGroup {
    
    // MARK: - Properties
    var chatGroupName: String
    var members: [CKReference]
    var messages: [CKReference] = []
    var cloudKitRecordID: CKRecordID?
    
    // MARK: - Initializer
    init(chatGroupName: String, members: [CKReference], messages: [CKReference]) {
        
        self.chatGroupName = chatGroupName
        self.members = members
        self.messages = messages
    }
}
