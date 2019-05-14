//
//  StoredData+CoreDataProperties.swift
//  DefaultsStore
//
//  Created by Jaiprakash Dadwani on 14/05/19.
//  Copyright © 2019 jai. All rights reserved.
//
//

import Foundation
import CoreData


extension StoredData {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<StoredData> {
        return NSFetchRequest<StoredData>(entityName: "StoredData")
    }

    @NSManaged public var key: NSObject
    @NSManaged public var value: NSObject?

}
