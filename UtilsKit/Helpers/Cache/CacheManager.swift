//
//  CacheManager.swift
//  UtilsKit
//
//  Created by RGMC on 04/04/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

/**
    Provide methods to cache and retrieve from cache codable objects.
 */
public class CacheManager: NSObject {
    
    /** The shared instance of the manager. */
    public static var shared: CacheManager = CacheManager()
    private var cache = UserDefaults.standard
    
    
    /**
     Cache data with key.
     
     The data needs to conforms to Codable protocol.
    
     - parameter object: the data compliant with `Codable` protocol.
     
     - parameter key: the key of the data to save under.
     */
    public func set<T: Codable>(_ object: T, key: String) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(object)
            cache.set(jsonData, forKey: key)
            cache.synchronize()
        }
        catch { }
    }
    
    /**
     Retrieve data from cache corresponding to key.
     
     The data needs to conforms to Codable protocol.
     
     `nil` means no data or an error during decoding.
     
     - parameter key: the key of the data to retrieve.
     
     - returns: the retrieved data or nil.
     */
    public func get<T: Codable>(forKey key: String?) -> T? {
        guard let key = key else { return nil }
        let json = cache.data(forKey: key)
        let object = T.decode(from: json)
        return object
    }
    
    /**
        Delete from cache data corresponding to key.
     
        - parameter key: the key of the data to delete.
     */
    public func delete(_ key: String) {
        cache.set(nil, forKey: key)
    }
}

/**  Protocol to make data cachable */
public protocol CacheObjectProtocol: Codable {
    /**  The key of the cached data */
    var cacheKey: String {get}
}

extension CacheObjectProtocol {
    
    /**
     Retrieve object from cache corresponding to key.
     
     `nil` means no data or an error during decoding.
     
     - parameter key: the key of the data to retrieve.
     
     - returns: the retrieved data or nil.
     */
    public static func get(forKey key: String) -> Self? {
        return CacheManager.shared.get(forKey: key)
    }
    
    /**
     Cache object.
     */
    public func save() {
        CacheManager.shared.set(self, key: self.cacheKey)
    }
}
