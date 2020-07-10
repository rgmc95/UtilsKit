//
//  RGMCNavigationController.swift
//  UtilsKit
//
//  Created by RGMC on 15/06/2020.
//  Copyright © 2020 RGMC. All rights reserved.
//

import Foundation
import UIKit

internal class RGMCNavigationController: UINavigationController {
    
    override internal var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }
}
