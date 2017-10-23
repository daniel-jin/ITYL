//
//  User+CloudKit.swift
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
        guard let username = cloudKitRecord[Keys.usernameKey] as? String else { return nil }
        
        // Self init with the checked username value
        self.init(username: username, recordID: cloudKitRecord.recordID)
    }
    
    // MARK: - Computed property to convert User into CKRecord
    var cloutKitRecord: CKRecord {
        
        // Initialize a CKRecord to return for the computed property
        let record = CKRecord(recordType: Keys.userRecordType, recordID: self.recordID)
        
        // Set the values
        record.setValue(username, forKey: Keys.usernameKey)
        
        return record
    }
}
