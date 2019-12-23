//
//  NetworkCache.swift
//  UtilsKit
//
//  Created by RGMC on 19/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

private let kUserDefaultsName = "UtilsKit.NetworkCache"

struct NetworkCache {
    
    //MARK: - Singleton
    public static let shared = NetworkCache()
    
    //MARK: - Variables
    private let defaults = UserDefaults(suiteName: kUserDefaultsName)!
    
    //MARK: - Functions
    func set(_ datas: Data?, for key: String) {
        defaults.setValue(datas, forKey: key)
    }
    
    func get(_ key: String) -> Data? {
        return defaults.value(forKey: key) as? Data
    }
    
    func delete(_ key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func resetCache() {
        self.defaults.removePersistentDomain(forName: kUserDefaultsName)
    }
}
