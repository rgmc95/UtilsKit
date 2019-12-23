//
//  UIApplication+Shared.swift
//  UtilsKit
//
//  Created by RGMC on 19/07/2019.
//  Copyright © 2019 RGMC. All rights reserved.
//

import UIKit

internal extension UIApplication {
    
    static var _shared: UIApplication? {
        #if APP_EXTENSION
        return nil
        #else
        return UIApplication.shared
        #endif
    }
}
