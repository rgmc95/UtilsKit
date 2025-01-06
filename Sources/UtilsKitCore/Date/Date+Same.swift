//
//  Date+Same.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import Foundation

extension Date {
	
	/// Checks if two dates fall on the same calendar day.
	///
	/// This method compares the day, month, and year components of the two dates to determine if they represent the same day.
	///
	/// - Parameter date: The date to compare with.
	/// - Returns: `true` if both dates are on the same calendar day; otherwise, `false`.
	///
	/// ### Example Usage
	/// ```swift
	/// let today = Date()
	/// let anotherDate = Calendar.current.date(byAdding: .day, value: -1, to: today)!
	///
	/// print(today.isSameDay(date: anotherDate)) // false
	/// ```
	public func isSameDay(date: Date) -> Bool {
		let day = Calendar.current.component(.day, from: self)
		let month = Calendar.current.component(.month, from: self)
		let year = Calendar.current.component(.year, from: self)
		
		let day2 = Calendar.current.component(.day, from: date)
		let month2 = Calendar.current.component(.month, from: date)
		let year2 = Calendar.current.component(.year, from: date)
		
		return year == year2 && month == month2 && day == day2
	}
	
	/// Checks if two dates fall within the same calendar month and year.
	///
	/// This method compares the month and year components of the two dates to determine if they represent the same month.
	///
	/// - Parameter date: The date to compare with.
	/// - Returns: `true` if both dates are within the same calendar month; otherwise, `false`.
	///
	/// ### Example Usage
	/// ```swift
	/// let firstDate = Date() // Assume this is January 15, 2025
	/// let secondDate = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
	///
	/// print(firstDate.isSameMonth(date: secondDate)) // true
	/// ```
	public func isSameMonth(date: Date) -> Bool {
		let month = Calendar.current.component(.month, from: self)
		let year = Calendar.current.component(.year, from: self)
		
		let month2 = Calendar.current.component(.month, from: date)
		let year2 = Calendar.current.component(.year, from: date)
		
		return year == year2 && month == month2
	}
	
	/// Checks if two dates fall within the same calendar year.
	///
	/// This method compares the year components of the two dates to determine if they represent the same year.
	///
	/// - Parameter date: The date to compare with.
	/// - Returns: `true` if both dates are within the same calendar year; otherwise, `false`.
	///
	/// ### Example Usage
	/// ```swift
	/// let firstDate = Date() // Assume this is 2025
	/// let secondDate = Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 1))!
	///
	/// print(firstDate.isSameYear(date: secondDate)) // true
	/// ```
	public func isSameYear(date: Date) -> Bool {
		let year = Calendar.current.component(.year, from: self)
		let year2 = Calendar.current.component(.year, from: date)
		
		return year == year2
	}
}
