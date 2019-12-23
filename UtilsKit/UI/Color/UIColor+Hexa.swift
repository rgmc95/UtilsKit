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
    public convenience init?(withHexString  hexString: String) {
        if hexString.hasPrefix("#") {
            let hex = String(hexString.dropFirst())
            
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 0
            
            var rgbValue: UInt64 = 0
            
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            
            self.init(
                red: r / 255,
                green: g / 255,
                blue: b / 255, alpha: 1
            )
        } else {
            return nil
        }
    }
}
