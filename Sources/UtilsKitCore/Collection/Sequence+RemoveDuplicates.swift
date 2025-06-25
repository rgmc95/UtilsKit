//
//  Sequence+RemoveDuplicates.swift
//  
//
//  Created by Michael Coqueret on 03/01/2020.
//

import Foundation

public extension Sequence where Element: Hashable {
	
	/// Return array without duplicate
	func removeDuplicates() -> [Element] {
		var set = Set<Element>()
		return self.filter { set.insert($0).inserted }
	}
}
