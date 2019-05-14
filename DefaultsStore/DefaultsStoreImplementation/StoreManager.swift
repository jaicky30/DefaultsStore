//
//  StoreManager.swift
//  DefaultsStore
//
//  Created by Jaiprakash Dadwani on 10/05/19.
//  Copyright © 2019 jai. All rights reserved.
//

import Foundation
import CoreData

public class StoreManager {
    
    private lazy var context = self.container.viewContext
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DefaultsStore")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                Log("***Error occured while loading persistent store \(error.localizedDescription)***")
            }
        }
        return container
    }()
    
    func getStoredDataInstance() -> StoredData {
        let entity = NSEntityDescription.entity(forEntityName: "StoredData", in: context)
        let storedData = StoredData.init(entity: entity!, insertInto: context)
        return storedData
    }
    
    func getStoredDataForKey(key: NSData) -> StoredData? {
        let fetchReq = StoredData.createFetchRequest()
        fetchReq.fetchLimit = 1
        fetchReq.predicate = NSPredicate(format: "key = %@", key)
        do {
            let value = try context.fetch(fetchReq)
            return value.first
        } catch {
            Log("***Error occured while fetching stored default - \(error.localizedDescription)***")
        }
        return nil
    }
    
    func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            Log("***Error occured while saving defaults - \(error.localizedDescription)***")
        }
    }
    
    func deleteAll() {
        
        let fetchReq = StoredData.createFetchRequest()
        do {
            let value = try context.fetch(fetchReq)
            for va in value {
                context.delete(va)
            }
        } catch {
            Log("***Error occured while fetching stored default - \(error.localizedDescription)***")
        }
        saveContext()
    }
}

class Log {
    
    @discardableResult
    required init(_ log: String) {
        #if DEBUG
        print(log)
        #endif
    }
    
    @discardableResult
    convenience init(_ log: String...) {
        
        var printableLog = ""
        if log.count > 1 {
            printableLog = log.joined()
        } else {
            printableLog = log.first ?? ""
        }
        self.init(printableLog)
    }
}
