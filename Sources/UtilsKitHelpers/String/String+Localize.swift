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
	public func localize() -> String {
		NSLocalizedString(self, comment: self)
	}
	
	/**
	 Localize the string with arguments
	 
	 - returns: a localized string.
	 */
	public func localize(_ args: CVarArg ...) -> String {
		String(format: NSLocalizedString(self, comment: self), args)
	}
}
