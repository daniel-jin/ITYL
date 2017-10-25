//
//  Message+CloudKit.swift
//  ITYL
//
//  Created by Daniel Jin on 10/23/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

extension Message {
    
    // MARK: - Failable initializer (convert a User CKRecord into a Message object)
    convenience init?(cloudKitRecord: CKRecord) {
        // Check for CKRecord's values and record type
        guard let messageText = cloudKitRecord[Keys.messageTextKey] as? String,
            let sendingUser = cloudKitRecord[Keys.sendingUserRefKey] as? CKReference,
            let chatGroupRef = cloudKitRecord[Keys.chatGroupRefKey] as? CKReference else { return nil }
        
        // Set the object properties with the cloutKidRecord's values
        self.init(message: messageText, sendingUser: sendingUser, chatGroupRef: chatGroupRef)
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert Message into CKRecord
extension CKRecord {
    convenience init(message: Message) {
        
        let recordID = message.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: Keys.messageRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(message.messageText, forKey: Keys.messageTextKey)
        self.setValue(message.sendingUser, forKey: Keys.sendingUserRefKey)
        self.setValue(message.chatGroupRef, forKey: Keys.chatGroupRefKey)
    }
}
