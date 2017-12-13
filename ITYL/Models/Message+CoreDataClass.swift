//
//  Message+CoreDataClass.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Message)
public class Message: NSManagedObject {

    // MARK: - Properties
    var sendingUser: CKReference?
    var chatGroupRef: CKReference?
    var cloudKitRecordID: CKRecordID?
    
    // MARK: - Failable initializer (convert a User CKRecord into a Message object)
    @discardableResult convenience init?(cloudKitRecord: CKRecord, chatGroup: ChatGroup, sentByUser: User) {
        
        // Check for CKRecord's values and record type
        guard let messageText = cloudKitRecord[Keys.messageTextKey] as? String,
            let sendingUser = cloudKitRecord[Keys.sendingUserRefKey] as? CKReference,
            let chatGroupRef = cloudKitRecord[Keys.chatGroupRefKey] as? CKReference,
            let deliverTime = cloudKitRecord["deliverTime"] as? NSDate else { return nil }
        
        // Set the object properties with the cloutKidRecord's values
        
        self.init(message: messageText, sentBy: sentByUser, sendingUser: sendingUser, chatGroupRef: chatGroupRef, chatGroup: chatGroup)
        self.deliverTime = deliverTime
        self.cloudKitRecordID = cloudKitRecord.recordID

    }
}

// MARK: - Extension on CKRecord to convert Message into CKRecord
extension CKRecord {
    convenience init?(message: Message) {
        
        let recordID = message.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: Keys.messageRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(message.messageText, forKey: Keys.messageTextKey)
        self.setValue(message.sendingUser, forKey: Keys.sendingUserRefKey)
        self.setValue(message.chatGroupRef, forKey: Keys.chatGroupRefKey)
        self.setValue(message.deliverTime, forKey: "deliverTime")
    }
}
