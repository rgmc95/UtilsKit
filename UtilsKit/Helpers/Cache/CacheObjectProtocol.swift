//
//  CacheObjectProtocol.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 07/05/2020.
//  Copyright © 2020 iD.apps. All rights reserved.
//

import Foundation

/**  Protocol to make data cachable */
public protocol CacheObjectProtocol: Codable {
    /**  The key of the cached data */
    var cacheKey: String { get }
}

extension CacheObjectProtocol {
    
    /**
     Retrieve object from cache corresponding to key.
     
     `nil` means no data or an error during decoding.
     
     - parameter key: the key of the data to retrieve.
     
     - returns: the retrieved data or nil.
     */
    public static func get(forKey key: String) -> Self? {
        CacheManager.shared.get(forKey: key)
    }
    
    /**
     Cache object.
     */
    public func save() {
        CacheManager.shared.set(self, key: self.cacheKey)
    }
}
