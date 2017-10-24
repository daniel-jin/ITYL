//
//  Message.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

struct Message {
    
    // MARK: - Properties
    let messageText: String
    let sendingUser: CKReference
    var cloudKitRecordID: CKRecordID?
    let chatGroup: CKReference
    
    // MARK: - Initializer
    init(message: String, sendingUser: CKReference, chatGroup: CKReference) {
        self.messageText = message
        self.sendingUser = sendingUser
        self.chatGroup = chatGroup
    }
}
