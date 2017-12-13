//
//  User+CoreDataClass.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(User)
public class User: NSManagedObject {

    var cloudKitRecordID: CKRecordID?
    // Reference to the default Apple Users record ID
    var appleUserRef: CKReference?
    
    // Reference to the chatGroups that the user belongs to
    var chatGroupsRef: [CKReference] = []
    
    // MARK: - Failable initializer (convert a User CKRecord into a User object)
    @discardableResult convenience init?(cloudKitRecord: CKRecord) {
        
        // Check for CKRecord's values and record type
        guard let username = cloudKitRecord[Keys.usernameKey] as? String,
            let appleUserRef = cloudKitRecord[Keys.appleUserRefKey] as? CKReference,
            let photoAsset = cloudKitRecord["UserPhoto"] as? CKAsset
            else { return nil }
        
        let chatGroupsRef = cloudKitRecord[Keys.chatGroupsRefKey] as? [CKReference] ?? []
        // Set the object properties with the cloutKidRecord's values
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        
        self.init(username: username, appleUserRef: appleUserRef, chatGroupsRef: chatGroupsRef, photoData: photoData)
        cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert User into CKRecord
extension CKRecord {
    convenience init?(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: Keys.userRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(user.username, forKey: Keys.usernameKey)
        self.setValue(user.appleUserRef, forKey: Keys.appleUserRefKey)
        
        if user.chatGroupsRef.count > 0 {
            self.setValue(user.chatGroupsRef, forKey: Keys.chatGroupsRefKey)
        }
        
        let asset = CKAsset(fileURL: user.temporaryPhotoURL)
        self.setValue(asset, forKey: Keys.userPhotoKey)
    }
}


// Conform to Equatable for ability to compare User objects
extension User {
    // Compare user objects by checking user's CK Record ID
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.cloudKitRecordID == rhs.cloudKitRecordID
    }
}

