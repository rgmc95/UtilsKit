//
//  Sequence+Contains.swift
//  UtilsKit
//
//  Created by RGMC on 24/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

public extension Sequence where Element: Equatable {
	
	/**
	 Check if an array contains all elements
	 
	 - parameter elements: the elements to find.
	 
	 - returns: a `boolean`value indicating if the array contains all elements.
	 */
	func containsAll(_ elements: any Sequence<Element>) -> Bool {
		for element in elements where !self.contains(element) {
			return false
		}
		return true
	}
}
