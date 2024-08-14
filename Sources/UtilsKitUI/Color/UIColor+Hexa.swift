//
//  UIColor+Hexa.swift
//  UtilsKit
//
//  Created by RGMC on 11/05/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /**
     Custom initializer to create a UIColor from a hexadecimal code.
     
     - parameter withHexString: Hexadecimal code (#....).
     */
    public convenience init?(withHexString hex: String) {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if cString.hasPrefix("#") {
			cString.remove(at: cString.startIndex)
		}
		
		if cString.count != 6 {
			return nil
		}
		
		var rgbValue:UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
				  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
				  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
				  alpha: CGFloat(1.0))
	}

    /**
     Custom initializer to get hexadecimal string code of current color
     - output : Hexadecimal code "#....".
     */
    public func toHexString() -> String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

            return String(format: "#%06x", rgb)
    }
}
