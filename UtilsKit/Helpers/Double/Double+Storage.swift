//
//  Double+Storage.swift
//  UtilsKit
//
//  Created by RGMC on 10/07/2020.
//  Copyright © 2020 RGMC. All rights reserved.
//

import Foundation

extension Int {
    
    /**
     Considering the value is in bytes, format it in the most appropriate unit depening on the locale
     
     - parameter maximumFractionDigits : Maximum fraction digits. Default 2
     - returns: The formated result
     
     ~~~
     let value = 1000
     print(value.toStorage()) // prints `1 kB`
     ~~~
     */
    @available(iOS 13.0, *)
    public func toStorage(maximumFractionDigits: Int = 2) -> String {
        Double(self).toStorage(maximumFractionDigits: maximumFractionDigits)
    }
}

extension Double {
    
    /**
     Considering the value is in bytes, format it in the most appropriate unit depening on the locale
     
     - parameter maximumFractionDigits : Maximum fraction digits. Default 2
     - returns: The formated result
     
     ~~~
     let value = 1000
     print(value.toStorage()) // prints `1 kB`
     ~~~
     */
    @available(iOS 13.0, *)
    public func toStorage(maximumFractionDigits: Int = 2) -> String {
        let nbFormatter = NumberFormatter()
        nbFormatter.maximumFractionDigits = maximumFractionDigits
        
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        formatter.numberFormatter = nbFormatter
        formatter.unitOptions = .naturalScale
        
        let measure = Measurement(value: self, unit: UnitInformationStorage.bytes)
        if self >= 1e15 {
            return formatter.string(from: measure.converted(to: .petabytes))
        } else if self >= 1e12 {
            return formatter.string(from: measure.converted(to: .terabytes))
        } else if self >= 1e9 {
            return formatter.string(from: measure.converted(to: .gigabytes))
        } else if self >= 1e6 {
            return formatter.string(from: measure.converted(to: .megabytes))
        } else if self >= 1e3 {
            return formatter.string(from: measure.converted(to: .kilobytes))
        } else {
            return formatter.string(from: measure.converted(to: .bytes))
        }
    }
}
