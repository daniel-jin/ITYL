//
//  Message+Convenience.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension Message {
    
    // MARK: - Initializer
    @discardableResult convenience init(message: String, sentBy: User, sendingUser: CKReference, chatGroupRef: CKReference, chatGroup: ChatGroup, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.messageText = message
        self.sentBy = sentBy
        self.sendingUser = sendingUser
        self.chatGroupRef = chatGroupRef
        self.chatGroup = chatGroup
        self.recordIDString = "NOT SYNCED YET"
        self.deliverTime = NSDate()
    }
    
}
