//
//  UIApplication+Info.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 25/06/2025.
//

import UIKit

public extension UIApplication {
	
	/**
	 The current version of the application.
	 
	 This property retrieves the application's version number from the main bundle's info dictionary using the key `"CFBundleShortVersionString"`. This is typically the version number displayed to users and in the App Store.
	 
	 - Returns: A string representing the application's version number, or an empty string if the version number cannot be found.
	 */
	func getVersion() -> String {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
	}
	
	/**
	 The build number of the application.
	 
	 This property retrieves the application's build number from the main bundle's info dictionary using the key `"CFBundleVersion"`. The build number is often used internally to track different builds of the application.
	 
	 - Returns: A string representing the application's build number, or an empty string if the build number cannot be found.
	 */
	func getBundleVersion() -> String {
		Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
	}
}
