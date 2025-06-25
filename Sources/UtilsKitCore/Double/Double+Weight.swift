//
//  Double+Weight.swift
//  UtilsKit
//
//  Created by Thibaud Lambert on 30/11/2021.
//  Copyright © 2020 RGMC. All rights reserved.
//

import Foundation

extension Double {
	/**
	 Considering the value is weight, format it in the most appropriate unit depening on the locale
	 
	 - parameter maximumFractionDigits : Maximum fraction digits. Default 2
	 - parameter locale : Locale. Default current
	 - returns: The formated result
	 
	 ~~~
	 let value = 1000
	 print(value.toStorage()) // prints `1 T`
	 ~~~
	 */
	public func toWeight(minimumFractionDigits: Int = 0,
						 maximumFractionDigits: Int = 0,
				  locale: Locale = .current) -> String {
        let nbFormatter = NumberFormatter()
		nbFormatter.locale = locale
		nbFormatter.minimumFractionDigits = minimumFractionDigits
        nbFormatter.maximumFractionDigits = maximumFractionDigits
        
        let formatter = MassFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter = nbFormatter
        
        return formatter.string(fromKilograms: self)
    }
}

extension Int {
	
	/**
	 Considering the value is weight, format it in the most appropriate unit depening on the locale
	 
	 - parameter maximumFractionDigits : Maximum fraction digits. Default 2
	 - parameter locale : Locale. Default current
	 - returns: The formated result
	 
	 ~~~
	 let value = 1000
	 print(value.toStorage()) // prints `1 T`
	 ~~~
	 */
	public func toWeight(minimumFractionDigits: Int = 0,
						 maximumFractionDigits: Int = 0,
						 locale: Locale = .current) -> String {
		Double(self).toWeight(minimumFractionDigits: minimumFractionDigits,
							  maximumFractionDigits: maximumFractionDigits,
							  locale: locale)
	}
}
