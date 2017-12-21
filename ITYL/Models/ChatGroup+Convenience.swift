//
//  ChatGroup+Convenience.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CoreData

extension ChatGroup {
    
    // MARK: - Initializer
    convenience init(name: String, users: [User], subscriptionID: String, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.users = NSSet(array: users)
        self.subscriptionID = subscriptionID
        self.recordIDString = "NOT SYNCED YET"
    }
}
