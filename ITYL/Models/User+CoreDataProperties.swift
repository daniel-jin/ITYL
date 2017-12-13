//
//  User+CoreDataProperties.swift
//  ITYL
//
//  Created by Daniel Jin on 12/13/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var username: String?
    @NSManaged public var recordIDString: String?
    @NSManaged public var chatGroups: NSSet?

}

// MARK: Generated accessors for chatGroups
extension User {

    @objc(addChatGroupsObject:)
    @NSManaged public func addToChatGroups(_ value: ChatGroup)

    @objc(removeChatGroupsObject:)
    @NSManaged public func removeFromChatGroups(_ value: ChatGroup)

    @objc(addChatGroups:)
    @NSManaged public func addToChatGroups(_ values: NSSet)

    @objc(removeChatGroups:)
    @NSManaged public func removeFromChatGroups(_ values: NSSet)

}
