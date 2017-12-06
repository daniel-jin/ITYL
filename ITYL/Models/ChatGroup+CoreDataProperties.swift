//
//  ChatGroup+CoreDataProperties.swift
//  ITYL
//
//  Created by Daniel Jin on 12/5/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatGroup> {
        return NSFetchRequest<ChatGroup>(entityName: "ChatGroup")
    }

    @NSManaged public var name: String?

}
