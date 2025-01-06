//
//  File.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import SwiftUI

extension LocalizedStringKey {
	
	/// Converts a `LocalizedStringKey` to its corresponding `String` value.
	///
	/// This method extracts the string key used in a `LocalizedStringKey` and returns its localized version using `NSLocalizedString`.
	///
	/// - Returns: A localized `String` corresponding to the `LocalizedStringKey`.
	///
	/// ### Example
	/// ```swift
	/// let key: LocalizedStringKey = "Hello"
	/// let localizedString = key.toString() // Returns the localized version of "Hello"
	/// ```
	public func toString() -> String {
		let mirror = Mirror(reflecting: self)
		for child in mirror.children {
			if let key = child.label, key == "key", let value = child.value as? String {
				return NSLocalizedString(value, comment: "")
			}
		}
		return ""
	}
}
