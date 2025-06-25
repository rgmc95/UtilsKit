//
//  Sequence+GroupByDate.swift
//  Trivel
//
//  Created by Michael Coqueret on 18/10/2024.
//  Copyright © 2024 Trivel. All rights reserved.
//

import Foundation

public extension Sequence {
	
	/**
	 Group a sequence by a `Hashable` value into a dictionnary
	 
	 - parameter key: a closure taking has parameter the iterated element and returning the key to sort sequence with.
	 
	 - returns: a dictionnary grouped with passed key and an array of iterated element for values.
	 */
	func group(byDate key: (Iterator.Element) -> Date, components: Set<Calendar.Component>) -> [(Date, [Iterator.Element])] {
		var categories: [Date: [Iterator.Element]] = [:]
		
		self.forEach { element in
			let date: Date = key(element)
			let components = Calendar.current.dateComponents(components, from: date)
			guard let key = Calendar.current.date(from: components) else { return }
			
			if case nil = categories[key]?.append(element) {
				categories[key] = [element]
			}
		}
		
		return categories.map { ($0.key, $0.value) }
	}
}
