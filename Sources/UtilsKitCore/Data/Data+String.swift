//
//  Data+String.swift
//  Trivel
//
//  Created by Michael Coqueret on 25/09/2024.
//

import Foundation

public extension Data {
	
	/**
	 Encodes the data as a URL-safe Base64 encoded string.
	 
	 This method first converts the data to a Base64 encoded string and then modifies it to be URL-safe by removing any backslashes. This is useful when you need to include the Base64 string in a URL, as certain characters are not allowed in URLs.
	 
	 - Returns: A URL-safe Base64 encoded string representation of the data.
	 */
	func urlSafeBase64EncodedString() -> String {
		let base64String = self.base64EncodedString()
		let safeString = base64String
			.replacingOccurrences(of: "\\", with: "")
		return safeString
	}
}
