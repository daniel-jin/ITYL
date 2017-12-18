//
//  Message+CoreDataProperties.swift
//  ITYL
//
//  Created by Daniel Jin on 12/15/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        let sortDescriptors = NSSortDescriptor(key: "deliverTime", ascending: true)
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        fetchRequest.sortDescriptors = [sortDescriptors]
        return fetchRequest
    }

    @NSManaged public var deliverTime: NSDate?
    @NSManaged public var messageText: String?
    @NSManaged public var recordIDString: String
    @NSManaged public var chatGroup: ChatGroup?
    @NSManaged public var sentBy: User?

}
