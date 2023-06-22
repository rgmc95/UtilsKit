//
//  String+Validate.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)

import Foundation

extension String {
    
    /**
     Check if the string is a valid email format.
     
     - returns: a boolean indicating if the string in a valid email format.
     */
    public var isValidEmail: Bool {
        let regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

#endif
