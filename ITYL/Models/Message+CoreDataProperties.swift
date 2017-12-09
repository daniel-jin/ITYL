//
//  Message+CoreDataProperties.swift
//  ITYL
//
//  Created by Daniel Jin on 12/8/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var deliverTime: NSDate?
    @NSManaged public var messageText: String?
    @NSManaged public var chatGroup: ChatGroup?
    @NSManaged public var sentBy: User?

}
