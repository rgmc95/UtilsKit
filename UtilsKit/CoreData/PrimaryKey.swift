//
//  PrimaryKey.swift
//  Hager Data Kit
//
//  Created by RGMC on 17/01/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

internal func primaryKeyfrom(_ value: Any?) -> PrimaryKey? {
    if let value: String = value as? String { return value }
    if let value: Int = value as? Int { return value }
    return nil
}

/**
 Protocol to transorm a type into a primary key.
 Used in `CoreDataManager` and `CoreDataModel` as the primary key of the entity
 */
public protocol PrimaryKey: CVarArg {
    var type: String { get }
}

extension String: PrimaryKey {
    /**
     Primary key value for type `String`
     */
    public var type: String { "%@" }
}

extension Int: PrimaryKey {
    /**
     Primary key value for type `Int`
     */
    public var type: String { "%d" }
}
