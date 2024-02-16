//
//  Set+InsertAll.swift
//
//
//  Created by Michael Coqueret on 16/02/2024.
//

public extension Set {
	
	/// Insert all elements in set
	mutating func insertAll(_ elements: [Element]) {
		self = self.union(elements)
	}
}
