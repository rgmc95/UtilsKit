//
//  String+ExtractValueFromRegex.swift
//  UtilsKit
//
//  Created by RGMC on 19/07/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import OSLog

#if canImport(UtilsKitCore)
import UtilsKitCore
#endif

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
            let matches = regex.matches(in: self,
                                        options: [],
                                        range: NSRange(location: 0,
                                                       length: self.count))
            
            return matches
                .compactMap { match -> [String]? in
                    guard case let lastRangeIndex = match.numberOfRanges - 1,
                          lastRangeIndex >= 1
                    else { return nil }
                    
                    return Array(1...lastRangeIndex).compactMap { index -> String? in
                        let capturedGroupIndex = match.range(at: index)
                        return (self as NSString).substring(with: capturedGroupIndex)
                    }
                }
                .flatMap { $0 }
        } catch {
			Logger.data.fault("Regex \(regex) in \(self) - \(error.localizedDescription)")
            return []
        }
    }
}
