//
//  UINavigationController+NavigationBar.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /**
        Clear the navigation bar background, navigation bar is present but transparent
     */
    public func setNavigationBarTransparent() {
        self.navigationBar.removeShadow()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.isNavigationBarHidden = false
        self.navigationBar.isTranslucent = true
    }
}
