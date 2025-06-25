//
//  Double+Rounded.swift
//  Trivel
//
//  Created by Michael Coqueret on 04/01/2025.
//  Copyright © 2025 Trivel. All rights reserved.
//

import Foundation

public extension Double {
	
	/**
	 Rounds the double value to a specified number of decimal places.
	 
	 This method takes a `Double` value and rounds it to the specified number of decimal places. It uses a divisor to shift the decimal point, rounds the number to the nearest integer, and then shifts the decimal point back to its original position.
	 
	 - Parameter places: The number of decimal places to round to. This must be a non-negative integer.
	 
	 - Returns: The rounded `Double` value.
	 */
	func round(to places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}
