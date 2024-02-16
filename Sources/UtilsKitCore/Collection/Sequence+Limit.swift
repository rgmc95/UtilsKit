//
//  Sequence+Limit.swift
//
//
//  Created by Michael Coqueret on 16/02/2024.
//

import Foundation

public extension Sequence {
	
	/**
	 Returns an array containing at most the specified number of elements from the beginning of the collection.
	 - Parameter limit: The maximum number of elements to include in the resulting array.
	 - Returns: An array containing at most the specified number of elements from the beginning of the collection.
	 - Complexity: O(1) if the underlying collection is a random-access collection; otherwise, O(k), where k is the specified limit.
	 **/
	func limit(_ limit: Int) -> [Element] {
		Array(self.prefix(limit))
	}
}
