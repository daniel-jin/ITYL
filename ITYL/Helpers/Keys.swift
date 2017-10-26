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
    static let UsersArrayChangeNotification = Notification.Name("UsersArrayChangeNotification")
    static let CurrentUserWasSetNotification = Notification.Name("currentUserWasSet")
    static let ChatGroupsArrayChangeNotification = Notification.Name("ChatGroupsArrayChangeNotification")
    static let MessagesArrayChangeNotification = Notification.Name("MessagesArrayChangeNotification")
    
    // MARK: - Keys for storyboard items
    
    // Segues
    static let toChatGroupMessagesSegue = "toChatGroupMessages"
    static let toSignUpVCSegue = "toSignUpVC"
    static let toChatGroupListsTVCSegue = "toChatGroupListTVC"
    
    // Cell identifiers
    static let chatGroupCellIdentifier = "chatGroupCell"
    static let messageCellIdentifier = "messageCell"

}
