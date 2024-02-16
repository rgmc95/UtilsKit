//
//  Sequence+RemoveDuplicates.swift
//  
//
//  Created by Michael Coqueret on 03/01/2020.
//

import Foundation

public extension Sequence where Element: Equatable {

    /// Return array without duplicate
	func removeDuplicates() -> [Element] {
        var result = [Element]()

		for value in self where !result.contains(value) {
			result.append(value)
        }

        return result
    }
}
