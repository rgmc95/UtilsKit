//
//  String+ExtractValueFromRegex.swift
//  UtilsKit
//
//  Created by RGMC on 19/07/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

extension String {
    
    /**
     Search value from regex in self.
     
     - parameter regex: the regex
     - returns: all string who respect the regex
     */
    public func values(forRegex regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = NSString(string: self)
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range(at: 1)) }
        } catch let error {
            log(.data, "Regex \(regex) in \(self)", error: error)
            return []
        }
    }
}
