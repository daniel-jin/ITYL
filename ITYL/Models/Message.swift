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
    let recordID: CKRecordID
    
    // MARK: - Initializer
    init(message: String, recordID: CKRecordID = CKRecord(recordType: Keys.messageRecordType).recordID) {
        self.messageText = message
        self.recordID = recordID
    }
}

