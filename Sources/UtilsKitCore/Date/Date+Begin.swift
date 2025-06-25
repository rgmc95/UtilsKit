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
}
