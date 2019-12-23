//
//  String+ASCII.swift
//  UtilsKit
//
//  Created by RGMC on 27/07/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

extension String {
    public var asciiValue: String? {
        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = self as NSString
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        let characters = matches.compactMap {
            UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)
        }.filter { (char) -> Bool in
            return NSCharacterSet.alphanumerics.contains(char)
        }.map { Character($0) }
        
        return String(characters)
    }
}

