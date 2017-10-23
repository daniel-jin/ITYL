//
//  User.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

struct User {
 
    // MARK: - Properties
    let username: String
    let recordID: CKRecordID
 
    // MARK: - Initializer
    init(username: String, recordID: CKRecordID = CKRecord(recordType: Keys.userRecordType).recordID) {
        self.username = username
        self.recordID = recordID
    }
}

// Conform to Equatable for ability to compare User objects
extension User: Equatable {
    // Compare user objects by checking user's CK Record ID
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}


static func ==<T: Equatable>(lhs: T, rhs: T) -> Bool {
    return lhs.
}
