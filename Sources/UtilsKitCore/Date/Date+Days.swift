//
//  Date+Days.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 17/01/2022.
//  Copyright © 2022 RGMC. All rights reserved.
//

import Foundation

extension Calendar {
	
	/**
	 Returns the number of full days between two dates.
	 
	 This method calculates the difference in full days between the two provided `Date` objects, considering the start of each day. The result is based on the calendar and takes into account any necessary time zone adjustments.
	 
	 - Parameters:
	 - from: The starting date to compare.
	 - to: The ending date to compare.
	 
	 - Returns:
	 An integer representing the number of full days between `from` and `to`. If the calculation fails, `-1` is returned.
	 */
	public func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
		let fromDate = startOfDay(for: from)
		let toDate = startOfDay(for: to)
		let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
		
		return numberOfDays.day ?? -1
	}
}
