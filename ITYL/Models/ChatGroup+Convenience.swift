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
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
    }
}
