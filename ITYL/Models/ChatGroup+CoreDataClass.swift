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
    @discardableResult convenience init?(cloudKitRecord: CKRecord, users: [User]) {
        // Check for CKRecord's values and record type
        guard let chatGroupName = cloudKitRecord[Keys.chatGroupTitleKey] as? String else { return nil}
        
        // Set the object properties with the cloutKidRecord's values
        self.init(name: chatGroupName, users: users)
        self.recordIDString = cloudKitRecord.recordID.recordName
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert Message into CKRecord
extension CKRecord {
    convenience init?(chatGroup: ChatGroup) {
        
        let recordName = UUID().uuidString
        
        let recordID = chatGroup.cloudKitRecordID ?? CKRecordID(recordName: recordName)
        
        // Init CKRecord
        self.init(recordType: Keys.chatGroupRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(chatGroup.name, forKey: Keys.chatGroupTitleKey)
    
        chatGroup.cloudKitRecordID = recordID
        chatGroup.recordIDString = recordName
        
        ChatGroupController.shared.saveToPersistantStore()
        
        // Convert users NSSet to array of Users
        guard let chatGroupUsers = chatGroup.users,
            let usersArray = Array(chatGroupUsers) as? [User],
            let userRecordsArray = usersArray.map({ CKRecord(user: $0) }) as? [CKRecord],
            let usersCKRefArray = userRecordsArray.map({ CKReference(record: $0, action: .none) }) as? [CKReference] else { return }

        self.setValue(usersCKRefArray, forKey: Keys.chatGroupMembersKey)
    }
}
