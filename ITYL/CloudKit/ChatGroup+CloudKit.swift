//
//  ChatGroup+CloudKit.swift
//  ITYL
//
//  Created by Daniel Jin on 10/23/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

extension ChatGroup {
    
    // MARK: - Failable initializer (convert a User CKRecord into a ChatGroup object)
    convenience init?(cloudKitRecord: CKRecord) {
        // Check for CKRecord's values and record type
        guard let chatGroupName = cloudKitRecord[Keys.chatGroupTitleKey] as? String,
            let members = cloudKitRecord[Keys.chatGroupMembersKey] as? [User],
            let messages = cloudKitRecord[Keys.chatGroupMessagesKey] as? [Message] else { return nil }
            
        // Set the object properties with the cloutKidRecord's values
        self.init(chatGroupName: chatGroupName, members: members, messages: messages)
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert Message into CKRecord
extension CKRecord {
    convenience init(chatGroup: ChatGroup) {
        
        let recordID = chatGroup.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: Keys.chatGroupRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(chatGroup.chatGroupName, forKey: Keys.chatGroupTitleKey)
        self.setValue(chatGroup.members, forKey: Keys.chatGroupMembersKey)
        self.setValue(chatGroup.messages, forKey: Keys.chatGroupMessagesKey)
    }
}
