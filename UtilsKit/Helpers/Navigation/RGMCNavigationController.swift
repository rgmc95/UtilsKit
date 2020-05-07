//
//  RGMCNavigationController.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 15/06/2020.
//  Copyright © 2020 iD.apps. All rights reserved.
//

import Foundation
import UIKit

internal class RGMCNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }
}
