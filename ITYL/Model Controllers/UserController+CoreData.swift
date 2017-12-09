//
//  UserController+CoreData.swift
//  ITYL
//
//  Created by Daniel Jin on 12/6/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import UIKit

extension UserController {
    
    // MARK: - SaveToPersistantStore()
    func saveToPersistantStore() {
        
        let moc = CoreDataStack.context
        
        do {
            return try moc.save()
        } catch {
            NSLog("Error saving to persistant store. \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Functions
    // Create
    func add(username: String, photoData: UIImage, completion: @escaping () -> Void = {}) {
        
        saveToPersistantStore()
        
    }
    
    // Delete
    func delete(user: User, completion: @escaping () -> Void = {}) {
        
        guard let moc = user.managedObjectContext else { return}
        
        moc.delete(user)
        
        saveToPersistantStore()
        
    }
    
}
