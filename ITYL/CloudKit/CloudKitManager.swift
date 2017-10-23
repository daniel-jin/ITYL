//
//  CloudKitManager.swift
//  ITYL
//
//  Created by Daniel Jin on 10/22/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    // Declare a public database for CKContainer.default
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    // Declare a private database for CKContainer
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    // MARK: - Fetch method
    func fetchRecords(ofType type: String, sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        // Create a CKQuery(with type and predicate)
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        
        // Assign sort descriptors for query
        query.sortDescriptors = sortDescriptors
        
        // Perform the query now that it's set up to fetch
        // TODO: Perform with private as well? When to do what?
        publicDatabase.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    // MARK: - Save method
    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        // Call save on the database
        // TODO: Public and private DB?
        publicDatabase.save(record) { (record, error) in
            completion(error)
        }
    }
    
    // MARK: - Delete method
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        // Call delete on the database
        // TODO: Public or private DB?
        publicDatabase.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    // TODO: - Modify record
}
