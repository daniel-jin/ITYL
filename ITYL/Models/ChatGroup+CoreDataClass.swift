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
        guard let chatGroupName = cloudKitRecord[Keys.chatGroupTitleKey] as? String,
            let users = cloudKitRecord[Keys.chatGroupMembersKey] as? [CKReference] else { return nil }
        
        var chatGroupUsers = [User]()
        
        for CKRef in users {
            CloudKitManager().fetchRecord(withID: CKRef.recordID, completion: { (record, error) in
                if let error = error {
                    NSLog("Error fetching user with provided Record ID: \(error.localizedDescription)")
                    return
                }
                
                if let record = record {
                    guard let user = User(cloudKitRecord: record) else { return }
                    chatGroupUsers.append(user)
                }
            })
        }
        
        // Set the object properties with the cloutKidRecord's values
        self.init(name: chatGroupName, users: chatGroupUsers)
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
