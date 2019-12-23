//
//  UIApplication+TopViewController.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

extension UIApplication {
    
    private func topViewController(_ baseViewController: UIViewController? = UIApplication._shared?.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = baseViewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = baseViewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = baseViewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let searchViewController = baseViewController as? UISearchController {
            return searchViewController.presentingViewController ?? baseViewController
        }
        
        return baseViewController
    }
    
    /**
     The current view controller if exists.
     */
    public var topViewController: UIViewController? {
        return self.topViewController()
    }
    
    /**
     The current alert view controller if exists.
     */
    public var topAlertView: UIAlertController? {
        return topViewController as? UIAlertController
    }
}
