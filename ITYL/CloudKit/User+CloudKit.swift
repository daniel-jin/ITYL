//
//  Person+CloudKit.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

extension User {
    
    // MARK: - Failable initializer (convert a User CKRecord into a User object)
    init?(cloudKitRecord: CKRecord) {
        // Check for CKRecord's values and record type
        guard let username = cloudKitRecord[Keys.usernameKey] as? String,
            let appleUserRef = cloudKitRecord[Keys.appleUserRefKey] as? CKReference,
            let chatGroupsRef = cloudKitRecord[Keys.chatGroupsRefKey] as? [CKReference],
            let photoAsset = cloudKitRecord[Keys.userPhotoKey] as? CKAsset else { return nil }
        
        // Set the object properties with the cloutKidRecord's values
        self.username = username
        self.appleUserRef = appleUserRef
        self.chatGroupsRef = chatGroupsRef
        self.cloudKitRecordID = cloudKitRecord.recordID
        
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.photoData = photoData
    }
}

// MARK: - Extension on CKRecord to convert User into CKRecord
extension CKRecord {
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: Keys.userRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(user.username, forKey: Keys.usernameKey)
        self.setValue(user.appleUserRef, forKey: Keys.appleUserRefKey)
        self.setValue(user.chatGroupsRef, forKey: Keys.chatGroupsRefKey)
        
        let asset = CKAsset(fileURL: user.temporaryPhotoURL)
        self.setValue(asset, forKey: Keys.userPhotoKey)
    }
}
