//
//  User+Convenience.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension User {
    
    // MARK: - Initializer
    @discardableResult convenience init(username: String, appleUserRef: CKReference, chatGroupsRef: [CKReference], photoData: Data?, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.username = username
        self.appleUserRef = appleUserRef
        self.chatGroupsRef = chatGroupsRef
        self.photoData = photoData as NSData?
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
