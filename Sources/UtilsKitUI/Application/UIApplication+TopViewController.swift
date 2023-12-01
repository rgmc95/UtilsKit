//
//  UIApplication+TopViewController.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

@available(iOSApplicationExtension, introduced: 1.0, unavailable)
extension UIApplication {
    
    /**
     The current view controller if exists.
     */
    public var topViewController: UIViewController? {
        self.topViewController()
    }
    
    /**
     The current alert view controller if exists.
     */
    public var topAlertView: UIAlertController? {
        topViewController as? UIAlertController
    }
    
	public func topViewController(_ baseViewController: UIViewController? = nil,
								   segue: Segue? = nil) -> UIViewController? {
        
        let currentBaseViewController: UIViewController?
            
        if let baseVC: UIViewController = baseViewController {
            currentBaseViewController = baseVC
        } else if #available(iOS 13.0, *),
                  let sceneDelegate: UIWindowSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate,
                  let rootVC: UIViewController = sceneDelegate.window??.rootViewController {
            currentBaseViewController = rootVC
        } else {
            currentBaseViewController = UIApplication.shared.delegate?.window??.rootViewController
        }

        if let nav: UINavigationController = currentBaseViewController as? UINavigationController {
			if let controller = nav.visibleViewController, !controller.isBottomSheet {
				return topViewController(nav.visibleViewController, segue: segue)
			}
			
			return topViewController(nav.topViewController, segue: segue)
        }
		
        if let tab: UITabBarController = currentBaseViewController as? UITabBarController {
            if let selected: UIViewController = tab.selectedViewController {
                return topViewController(selected, segue: segue)
            }
        }
		
		if let searchViewController: UISearchController = currentBaseViewController as? UISearchController {
			return searchViewController.presentingViewController ?? currentBaseViewController
		}
		
		if let presented: UIViewController = currentBaseViewController?.presentedViewController {
			if case .push = segue, presented.isBottomSheet {
				return currentBaseViewController
			} else {
				return topViewController(presented, segue: segue)
			}
		}
        
        return currentBaseViewController
    }
}

private extension UIViewController {
	
	var isBottomSheet: Bool {
		if #available(iOS 15.0, *) {
			if let sheet = self.sheetPresentationController {
				if sheet.detents.count == 1 && sheet.detents.first == .large() {
					return false
				}
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}
}
