//
//  UIImage+Encode.swift
//  UtilsKit
//
//  Created by David Douard on 08/02/2021.
//

import UIKit

extension UIImage {
    
    public convenience init?(base64String: String?) {
        guard let base64String = base64String  else { return nil }
        let temp = base64String.components(separatedBy: ",")
        var base64String_prepared: String
        if temp.count > 1 {
            base64String_prepared = temp[1]
        } else {
            base64String_prepared = temp[0]
        }
        guard let data = Data(base64Encoded: base64String_prepared, options: .ignoreUnknownCharacters) else { return nil }
        self.init(data: data)
    }
}

