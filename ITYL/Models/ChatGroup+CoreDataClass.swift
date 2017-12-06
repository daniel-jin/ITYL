//
//  ChatGroup+CoreDataClass.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(ChatGroup)
public class ChatGroup: NSManagedObject {
    
    var cloudKitRecordID: CKRecordID?

    // MARK: - Failable initializer (convert a User CKRecord into a ChatGroup object)
    @discardableResult convenience init?(cloudKitRecord: CKRecord) {
        // Check for CKRecord's values and record type
        guard let chatGroupName = cloudKitRecord[Keys.chatGroupTitleKey] as? String else { return nil }
        
        // Set the object properties with the cloutKidRecord's values
        self.init(name: chatGroupName)
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert Message into CKRecord
extension CKRecord {
    convenience init?(chatGroup: ChatGroup) {
        
        let recordID = chatGroup.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: Keys.chatGroupRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(chatGroup.name, forKey: Keys.chatGroupTitleKey)
        //        self.setValue(chatGroup.members, forKey: Keys.chatGroupMembersKey)
        //        self.setValue(chatGroup.messages, forKey: Keys.chatGroupMessagesKey)
    }
}
