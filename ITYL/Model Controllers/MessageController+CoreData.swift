//
//  MessageController+CoreData.swift
//  ITYL
//
//  Created by Daniel Jin on 12/6/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CoreData

extension MessageController {
    
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
    func add(message: Message, completion: @escaping () -> Void = {}) {
        
        saveToPersistantStore()
        
    }
    
    // Delete
    func delete(message: Message, completion: @escaping () -> Void = {}) {
        
        guard let moc = message.managedObjectContext else { return}
        
        moc.delete(message)
        
        saveToPersistantStore()
        
    }
    
    
}
