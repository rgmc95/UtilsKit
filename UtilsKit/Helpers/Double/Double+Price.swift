//
//  Double+Price.swift
//  UtilsKit
//
//  Created by RGMC on 08/08/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

extension Double {
    
    /**
     Self in price with currency and formatter.
     
     - parameter currency : Custom currency if needed
     - returns: self in price with currency.
     */
    public func toPrice(currency: String? = nil) -> String {
        let numberFormatter = NumberFormatter()
        
        if let currency: String = currency {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let price: String = numberFormatter.string(from: NSNumber(value: self)) {
                return "\(price) \(currency)"
            }
        } else {
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            if let price: String = numberFormatter.string(from: NSNumber(value: self)) {
                return price
            }
        }
        
        return ""
    }
}

extension Int {
    
    /**
     Self in price with currency and formatter.
     
     - parameter currency : Custom currency if needed
     - returns: self in price with currency.
     */
    public func toPrice(currency: String? = nil) -> String {
        Double(self).toPrice(currency: currency)
    }
}
