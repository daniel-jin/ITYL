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
    @discardableResult convenience init(message: String, sendingUser: CKReference, chatGroupRef: CKReference, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.messageText = message
        self.sendingUser = sendingUser
        self.chatGroupRef = chatGroupRef
        self.deliverTime = NSDate()
    }
    
}
