//
//  UserController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    // Singleton for model controller
    static let shared = UserController()
    
    // CloudKid Manager instance
    private let cloudKitManager = CloudKitManager()
    
    // MARK: - Properties
    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Keys.currentUserWasSetNotification, object: nil)
            }
        }
    }
    
    // Model object array
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                // Set up a notification center to broadcast when this array has been loaded/modified
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Keys.DidChangeNotification, object: self)
            }
        }
    }
    
    // MARK: - CRUD functions
    
    // Create
    func createUserWith(username: String, photoData: Data?, completion: @escaping (_ success: Bool) -> Void) {
        
        // Fetch default Apple 'Users' RecordID
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            guard let appleUserRecordID = appleUserRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            let user = User(username: username, appleUserRef: appleUserRef, chatGroupsRef: [CKReference](), photoData: photoData)
            
            // Get the CKRecord of the user object
            let userRecord = CKRecord(user: user)
            
            // Then use cloudKitManager save function
            self.cloudKitManager.save(userRecord) { (error) in
                
                // Check for error
                if let error = error {
                    NSLog(error.localizedDescription)
                    completion(false)
                    return
                }
                
                // Set current user and complete
                self.currentUser = user
                
                // Add the User item to the array
                self.users.insert(user, at: 0)
                completion(true)
            }
        }
    }
    
    // Fetch Current User
    func fetchCurrentUser(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        
        // Fetch default Apple 'Users' RecordID
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { print(error.localizedDescription) }
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            
            // Create the CKRef with the Apple 'User's recordID so that we can perform the fetch for the Custom User record
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            // Create a predicate with the ref that will go through all the users and filter to return the matching ref., i.e. custom user
            let predicate = NSPredicate(format: "appleUserRef == $@", appleUserRef)
            
            // Fetch the custom user record
            self.cloudKitManager.fetchRecordsWithType(Keys.usernameKey, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                
                guard let currentUserRecord = records?.first else { completion(false); return }
                
                let currentUser = User(cloudKitRecord: currentUserRecord)
                self.currentUser = currentUser
                completion(true)
            })
        }
    }
    // TODO: - Update/Modify
}
