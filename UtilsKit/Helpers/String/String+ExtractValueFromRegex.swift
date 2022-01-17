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
	 Check if self matches regex
	 
	 - parameter regex: the regex
	 */
	public func matches(regex: String) -> Bool {
		self.range(of: regex,
				   options: .regularExpression) != nil
	}
    
    /**
     Search value from regex in self.
     
     - parameter regex: the regex
     - returns: all string who respect the regex
     */
    public func values(forRegex regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = NSString(string: self)
            let results: [NSTextCheckingResult] = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range(at: 1)) }
        } catch {
            log(.data, "Regex \(regex) in \(self)", error: error)
            return []
        }
    }
}
