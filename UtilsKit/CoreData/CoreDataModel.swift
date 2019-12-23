//
//  CoreDataModel.swift
//  Hager Data Kit
//
//  Created by RGMC on 17/01/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import CoreData

/**
 JSON type definition
 */
public typealias JSON = [String: Any]

/**
 Protocol to facilitate the use of core data with `CoreDataManager` class
 Gives methods to manage the corresponding entity
 */
@available(iOS 10.0, *)
public protocol CoreDataUpdatable {
    static func update(with json: Any) -> Self?
}

/**
 Protocol to facilitate the use of core data with `CoreDataManager` class
 Gives methods to manage the corresponding entity
 */
@available(iOS 10.0, *)
public protocol CoreDataModel: CoreDataUpdatable where Self: NSManagedObject {
    /**
     The name of the core data entity
     */
    static var entityName: String {get}
    /**
     The primary key of the entity; basically an id used on CRUD operations
     */
    static var primaryKey: String {get}
    
    /**
     Do any core data operations on the entity here
     */
    static func decode(with data: Any) throws -> Self?
}

@available(iOS 10.0, *)
extension CoreDataModel {
    
    /**
     Get entity primary key
     */
    var primaryKey: PrimaryKey? {
        return primaryKeyfrom(self.value(forKey: Self.primaryKey))
    }
}
