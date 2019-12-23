//
//  NSLocale+Localize.swift
//  UtilsKit
//
//  Created by Radhouani on 08/06/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

extension NSLocale {
    
    static public let kLanguageDidChange: String = "KLanguage_Did_Change"
    
    /**
     The current language.
     
     - returns: the current language.
     */
    static public var currentLanguage: String {
        get {
            if let currentLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") {
                return currentLanguage
            } else {
                // User never set his preferred language
                return NSLocale.preferredLanguages.first!
            }
        }
        set {
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(kLanguageDidChange), object: nil)
        }
    }
}
