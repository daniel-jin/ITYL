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

class User {
 
    // MARK: - Properties
    var username: String
    var cloudKitRecordID: CKRecordID?
    var photoData: Data?
    
    // Reference to the default Apple Users record ID
    var appleUserRef: CKReference
    
    // Reference to the chatGroups that the user belongs to
    var chatGroupsRef: [CKReference] = []
 
    // MARK: - Initializer
    init(username: String, appleUserRef: CKReference, chatGroupsRef: [CKReference], photoData: Data?) {
        self.username = username
        self.appleUserRef = appleUserRef
        self.chatGroupsRef = chatGroupsRef
        self.photoData = photoData
    }
    
    // MARK: - Temp URL for photo
    var temporaryPhotoURL: URL {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }

}

// Conform to Equatable for ability to compare User objects
extension User: Equatable {
    // Compare user objects by checking user's CK Record ID
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.cloudKitRecordID == rhs.cloudKitRecordID
    }
}
