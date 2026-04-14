//
//  Date+Same.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import Foundation

extension Date {
	
	/// Checks if two dates are the same based on specified calendar components.
	/// - Parameters:
	///   - date: The date to compare with the current instance.
	///   - components: A set of calendar components to consider for the comparison (e.g., year, month, day).
	/// - Returns: A boolean indicating whether the specified components of the two dates are the same.
	public func isSame(date: Date, components: Set<Calendar.Component>) -> Bool {
		let components1 = Calendar.current.dateComponents(components, from: self)
		let components2 = Calendar.current.dateComponents(components, from: date)
		
		return components.allSatisfy { component in
			components1.value(for: component) == components2.value(for: component)
		}
	}
}
