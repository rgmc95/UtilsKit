//
//  String+Localize.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

fileprivate var _currentLanguages: [String]?

extension Locale {
	
	public static var currentLanguages: [String] {
		get {
			_currentLanguages ?? (UserDefaults.standard.array(forKey: "AppleLanguages") as? [String]) ?? []
		}
		set {
			_currentLanguages = newValue
		}
	}
}

extension String {
	
	/**
	 Localize the string.
	 
	 - returns: a localized string.
	 */
	public var localized: String {
		for language in Locale.currentLanguages {
			if let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
			   let bundle = Bundle(path: bundlePath) {
				return NSLocalizedString(self,
										 bundle: bundle,
										 value: NSLocalizedString(self, comment: ""),
										 comment: "")
			}
		}
		
		return NSLocalizedString(self, comment: "")
	}
	
	/**
	 Localize the string.
	 
	 - returns: a localized string or nil.
	 */
	public var localizedOrNil: String? { (localized != self ? localized : nil) }
}
