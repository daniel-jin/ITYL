//
//  User.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

struct User {
 
    // MARK: - Properties
    let username: String
    var cloudKitRecordID: CKRecordID?
//    var photo: UIImage?
    
    // Reference to the default Apple Users record ID
    var appleUserRef: CKReference
    
    // Reference to the chatGroups that the user belongs to
    var chatGroupsRef: [CKReference] = []
 
    // MARK: - Initializer
    init(username: String, appleUserRef: CKReference, chatGroupsRef: [CKReference]) {
        self.username = username
        self.appleUserRef = appleUserRef
        self.chatGroupsRef = chatGroupsRef
    }
}

// Conform to Equatable for ability to compare User objects
extension User: Equatable {
    // Compare user objects by checking user's CK Record ID
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.cloudKitRecordID == rhs.cloudKitRecordID
    }
}
