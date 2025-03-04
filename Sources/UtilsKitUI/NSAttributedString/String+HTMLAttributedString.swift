//
//  String+HTMLAttributedString.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import UIKit
import OSLog

#if canImport(UtilsKitCore)
import UtilsKitCore
#endif

extension String {
    
    /**
     Transform a string containing HTML into `NSAttributedString`.
     
     - returns: a `NSAttributedString` representing the HTML of the string.
     */
	public var htmlToAttributedString: NSMutableAttributedString? {
		guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
			return nil
		}
		
		do {
			let attributedString = try NSMutableAttributedString(data: data,
																 options:
																	[
																		.documentType: NSAttributedString.DocumentType.html,
																		.characterEncoding: String.Encoding.utf8.rawValue
																	],
																 documentAttributes: nil)
			return attributedString
		} catch {
			Logger.string.fault("String \(self) to htmlAttributedString - \(error.localizedDescription)")
			return nil
		}
	}
}
