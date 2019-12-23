//
//  NetworkCache.swift
//  UtilsKit
//
//  Created by RGMC on 19/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

struct NetworkCache {
    
    //MARK: - Singleton
    public static let shared = NetworkCache()
    
    //MARK: - Variables
    private var defaults = UserDefaults.standard
    
    //MARK: Key
    private let allKeyCacheKey: String = "UtilsKit.cache.allKeys"
    private var allKeys: [String] {
        return (defaults.value(forKey: allKeyCacheKey) as? [String]) ?? []
    }
    
    //MARK: - Functions
    func set(_ datas: Data?, for key: String) {
        defaults.setValue(datas, forKey: key)
        self.add(key: key)
    }
    
    func get(_ key: String) -> Data? {
        return defaults.value(forKey: key) as? Data
    }
    
    func delete(_ key: String) {
        defaults.removeObject(forKey: key)
        self.remove(key: key)
    }
    
    //MARK: Key
    private func add(key: String) {
        var currentAllKeys = self.allKeys
        if !currentAllKeys.contains(key) {
            currentAllKeys.append(key)
        }
        defaults.set(currentAllKeys, forKey: allKeyCacheKey)
    }
    
    private func remove(key: String) {
        defaults.set(allKeys.filter({$0 != key}), forKey: allKeyCacheKey)
    }
    
    func resetCache() {
        for key in allKeys {
            defaults.removeObject(forKey: key)
        }
        defaults.removeObject(forKey: allKeyCacheKey)
    }
    
}
