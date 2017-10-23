//
//  UserController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Properties
    
    // Singleton for model controller
    static let shared = UserController()
    
    // CloudKid Manager instance
    private let cloudKitManager = CloudKitManager()
    
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
    
    // Initialize - fetch/refresh
    init() {
        refreshData()
    }
    
    // Create
    func create(user: User, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        // User coputed property on User model to get CKRecord
        let record = user.cloutKitRecord
        
        // Then use cloudKitManager save function
        cloudKitManager.save(record) { (error) in
            
            defer { completion(error) }
            
            // Check for error
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            // Add the User item to the array
            self.users.insert(user, at: 0)
        }
    }
    
    // Fetch/Refresh
    func refreshData(completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        // Call the fetch method from CloudKitManager
        cloudKitManager.fetchRecords(ofType: Keys.userRecordType) { (records, error) in
            
            defer { completion(error) }
            
            // Handle error
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            // Check for records, then flatMap records to array
            guard let records = records else { return }
            self.users = records.flatMap { User(cloudKitRecord: $0) }
        }
    }
    
    // TODO: - Update/Modify
    
}
