//
//  Date+Begin.swift
//  Trivel
//
//  Created by Michael Coqueret on 29/08/2024.
//

import Foundation

public extension Date {
	
	/**
	 Returns the start of the day for the given date.
	 
	 This method calculates the start of the day by extracting the year, month, and day components from the date, effectively setting the time to midnight (00:00:00).
	 
	 - Returns: A new `Date` object set to the start of the day (midnight) of the original date. If the calculation fails, it returns the original date.
	 */
	func getStartOfDay() -> Date {
		Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) ?? self
	}
	
	/**
	 Returns the end of the day for the given date.
	 
	 This method calculates the end of the day by setting the time components to 23:59:59 while preserving the year, month, and day of the original date.
	 
	 - Returns: A new `Date` object set to the end of the day (23:59:59) of the original date. If the calculation fails, it returns the original date.
	 */
	func getEndOfDay() -> Date {
		var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
		component.hour = 23
		component.minute = 59
		component.second = 59
		
		return Calendar.current.date(from: component) ?? self
	}
	
	/// Returns the first day of the month for the current date.
	///
	/// This method extracts the year and month components from the current date
	/// and constructs a new `Date` representing midnight on the 1st of that month,
	/// using the user's current calendar.
	///
	/// - Returns: A `Date` representing the start of the current month (day 1, at 00:00:00).
	///            Falls back to `self` if the date cannot be constructed.
	///
	/// - Example:
	/// ```swift
	/// let date = Date() // e.g. April 13, 2026 at 14:35
	/// let startOfMonth = date.getStartOfMonth() // April 1, 2026 at 00:00:00
	/// ```
	func getStartOfMonth() -> Date {
		Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? self
	}
}
