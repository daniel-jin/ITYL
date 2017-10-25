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
    let chatGroupRef: CKReference
    var cloudKitRecordID: CKRecordID?
    
    // MARK: - Initializer
    init(message: String, sendingUser: CKReference, chatGroupRef: CKReference) {
        self.messageText = message
        self.sendingUser = sendingUser
        self.chatGroupRef = chatGroupRef
    }
}
