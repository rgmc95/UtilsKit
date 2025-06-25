//
//  Double+Price.swift
//  UtilsKit
//
//  Created by RGMC on 08/08/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

extension Double {
	
	private var isDecimal: Bool {
		Double(Int(self)) != self
	}
	
	/**
	 Self in price with currency and formatter.
	 
	 - parameter currency : Custom currency if needed
	 - returns: self in price with currency.
	 */
	public func toPrice(currency: String? = nil) -> String {
		if self.isDecimal {
			return self.toPrice(currency: currency, minimumFractionDigits: 2)
		} else {
			return self.toPrice(currency: currency, minimumFractionDigits: 0)
		}
	}
    
    /**
     Self in price with currency and formatter.
     
     - parameter currency : Custom currency if needed
     - returns: self in price with currency.
     */
	public func toPrice(currency: String? = nil,
						minimumFractionDigits: Int,
						maximumFractionDigits: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
		numberFormatter.minimumFractionDigits = minimumFractionDigits
		numberFormatter.maximumFractionDigits = maximumFractionDigits
        
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
	
	/**
	 Self in price with currency and formatter.
	 
	 - parameter currencyCode : Currency code
	 - returns: self in price with currency.
	 */
	public func toPrice(currencyCode: String?) -> String {
		if self.isDecimal {
			return self.toPrice(currencyCode: currencyCode, minimumFractionDigits: 2)
		} else {
			return self.toPrice(currencyCode: currencyCode, minimumFractionDigits: 0)
		}
	}
	
	/**
	 Self in price with currency and formatter.
	 
	 - parameter currencyCode : Currency code
	 - returns: self in price with currency.
	 */
	public func toPrice(currencyCode: String?,
						minimumFractionDigits: Int,
						maximumFractionDigits: Int = 2) -> String {
		guard let currencyCode = currencyCode else {
			return self.toPrice(minimumFractionDigits: minimumFractionDigits,
								maximumFractionDigits: maximumFractionDigits)
		}
		
		let currency = NSLocale(localeIdentifier: currencyCode)
			.displayName(forKey: .currencySymbol, value: currencyCode)
		return self.toPrice(currency: currency ?? currencyCode,
							minimumFractionDigits: minimumFractionDigits,
							maximumFractionDigits: maximumFractionDigits)
	}
}

extension Int {
    
    /**
     Self in price with currency and formatter.
     
     - parameter currency : Custom currency if needed
     - returns: self in price with currency.
     */
	public func toPrice(currency: String? = nil,
						minimumFractionDigits: Int = 0,
						maximumFractionDigits: Int = 2) -> String {
		Double(self).toPrice(currency: currency,
							 minimumFractionDigits: minimumFractionDigits,
							 maximumFractionDigits: maximumFractionDigits)
    }
	
	/**
	 Self in price with currency and formatter.
	 
	 - parameter currencyCode : Currency code
	 - returns: self in price with currency.
	 */
	public func toPrice(currencyCode: String?,
						minimumFractionDigits: Int = 0,
						maximumFractionDigits: Int = 2) -> String {
		Double(self).toPrice(currencyCode: currencyCode,
							 minimumFractionDigits: minimumFractionDigits,
							 maximumFractionDigits: maximumFractionDigits)
	}
}
