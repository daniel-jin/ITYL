//
//  Keys.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation

struct Keys {
    
    // MARK: - Keys for CloudKit
    static let appleUserRefKey = "appleUserRef"
    
    static let chatGroupsRefKey = "chatGroupsRef"
    static let chatGroupRefKey = "chatGroupRef"
    static let chatGroupMembersKey = "chatGroupMembers"
    
    static let userRecordType = "User"
    static let usernameKey = "Username"
    static let userPhotoKey = "UserPhoto"
    
    static let messageRecordType = "Message"
    static let messageTextKey = "MessageText"
    static let sendingUserRefKey = "SendingUser"
    static let receivingUsersRefKey = "ReceivingUser"
    
    static let chatGroupRecordType = "ChatGroup"
    static let chatGroupTitleKey = "ChatGroupTitle"
    static let chatGroupMessagesKey = "ChatGroupMessages"
    
    // MARK: - Keys for notification center
    static let DidChangeNotification = Notification.Name("DidChangeNotification")
    static let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    // MARK: - Keys for storyboard items
    
    
}
