//
//  NavigationProtocol.swift
//  UtilsKit
//
//  Created by RGMC on 05/04/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol provides a useful navigation stack management.
 */
public protocol NavigationProtocol {
    
    /**
     Kind of segue for the view controller animation.
     */
    var navigationSegue: Segue {get set}
    
    /**
     Instance Identifier
     */
    var instanceIdentifier: String? {get}
    
    /**
     Sender
     */
    var previousViewController: UIViewController? {get set}
}

extension NavigationProtocol where Self: UIViewController {
    
    /**
     
     Push the view controller on top of the navigation stack or specific controller.
     
     - parameter controller: controller to push the view controller on top of. Default is nil.
     
     - parameter animated: animate or not. Default is true.
     
     - parameter completion: completion handler called upon push. Default is nil.
     
     */
    public func push(from controller: UIViewController? = nil,
                     animated: Bool = true,
                     completion: (()->Void)? = nil) {
        
        Segue.push.present(self,
                           from: controller,
                           animated: animated,
                           completion: completion)
    }
    
    /**
     
     Push the view controller on detail side on the current split view contoller or specific controller.
     
     - parameter controller: controller to push the view controller on on detail side. Default is nil.
     
     - parameter withNavigationController: add a UINavigationController or not. Default is false.
     
     - parameter animated: animate or not. Default is true.
     
     - parameter completion: completion handler called upon push. Default is nil.
     
     */
    public func popover(from controller: UIViewController? = nil,
                        withNavigationController: Bool = false,
                        animated: Bool = true,
                        completion: (()->Void)? = nil) {
        
        Segue.popover.present(self,
                              from: controller,
                              withNavigationController: withNavigationController,
                              animated: animated,
                              completion: completion)
    }
    
    /**
     
     Push the view controller on detail side on the current split view contoller or specific controller.
     
     - parameter controller: controller to push the view controller on on detail side. Default is nil.
     
     - parameter anchor: view to anchor the view controller.
     
     - parameter withNavigationController: add a UINavigationController or not. Default is false.
     
     - parameter animated: animate or not. Default is true.
     
     - parameter completion: completion handler called upon push. Default is nil.
     
     */
    public func popover(from controller: UIViewController? = nil,
                        anchor: UIView?,
                        withNavigationController: Bool = false,
                        animated: Bool = true,
                        completion: (()->Void)? = nil) {
        
        Segue.popover.present(self,
                              from: controller,
                              withNavigationController: withNavigationController,
                              fromView: anchor,
                              animated: animated,
                              completion: completion)
    }
    
    
    /**
     
     Push the view controller on detail side on the current split view contoller or specific controller.
     
     - parameter controller: controller to push the view controller on on detail side. Default is nil.
     
     - parameter anchor: UIBarButtonItem to anchor the view controller.
     
     - parameter withNavigationController: add a UINavigationController or not. Default is false.
     
     - parameter animated: animate or not. Default is true.
     
     - parameter completion: completion handler called upon push. Default is nil.
     
     */
    public func popover(from controller: UIViewController? = nil,
                        anchor: UIBarButtonItem?,
                        withNavigationController: Bool = false,
                        animated: Bool = true,
                        completion: (()->Void)? = nil) {
        
        Segue.popover.present(self,
                              from: controller,
                              withNavigationController: withNavigationController,
                              fromBarButtonItem: anchor,
                              animated: animated,
                              completion: completion)
    }
    
    /**
     
     Present the view controller on top of the navigation stack or specific controller.
     
     - parameter controller: controller to present the view controller on top of. Default is nil.
     
     - parameter withNavigationController: present the view controller embeded in a navigation controller. Default is false.
     
     - parameter animated: animate or not. Default is true.
     
     - parameter completion: completion handler called upon push. Default is nil.
     
     */
    public func modal(from controller: UIViewController? = nil,
                      withNavigationController: Bool = false,
                      animated: Bool = true,
                      completion: (()->Void)? = nil) {
        
        Segue.modal.present(self,
                            from: controller,
                            withNavigationController: withNavigationController,
                            animated: animated,
                            completion: completion)
    }
    
    /**
     
     Present the view controller on top of the navigation stack or specific controller with blur effect.
     
     - parameter controller: controller to present the view controller on top of. Default is nil.
     
     - parameter animated: animate or not. Default is true.
     
     - parameter completion: completion handler called upon push. Default is nil.
     
     */
    public func modalBlur(from controller: UIViewController? = nil,
                          animated: Bool = true,
                          completion: (()->Void)? = nil) {
        
        Segue.modalBlur.present(self,
                                from: controller,
                                animated: animated,
                                completion: completion)
    }
    
    /**
     
     Close the view controller.
     
     - parameter completion: completion handler called upon push.
     
     */
    public func close(_ completion: (()->Void)? = nil, animated: Bool = true) {
        self.navigationSegue.close(self, animated: animated, completion: {
            completion?()
        })
    }
}

/**
 
 Styles of the navigation.
 
 Navigation styles provided:
 
 - push
 - modal
 - modalBlur
 
 */
public enum Segue {
    case push
    case modal
    case modalBlur
    case popover
    
    public func present<T: UIViewController & NavigationProtocol>(
        _ controller: T?,
        from currentViewController: UIViewController? = nil,
        withNavigationController: Bool = false,
        fromView view: UIView? = nil,
        fromBarButtonItem barButtonItem: UIBarButtonItem? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            guard let currentViewController = currentViewController ?? UIApplication._shared?.topViewController else { return }
            guard var controller = controller else { return }
            
            if
                let currentViewController = currentViewController as? T,
                let currentIdentifier = currentViewController.instanceIdentifier,
                let controllerIdentifier = controller.instanceIdentifier,
                controllerIdentifier == currentIdentifier
            {
                    return
            }
            controller.previousViewController = currentViewController
            
            // If popup close it, open controller then re-open popup
            if let alertViewController = UIApplication._shared?.topAlertView {
                alertViewController.dismiss(animated: false, completion: {
                    self.present(controller, from: currentViewController, withNavigationController: withNavigationController, animated: animated, completion: {
                        UIApplication._shared?.topViewController?.present(alertViewController, animated: false, completion: nil)
                    })
                })
                return
            }
            
            switch self {
            case .push:
                if let navigationController = (currentViewController as? UINavigationController) ?? currentViewController.navigationController {
                    controller.navigationSegue = .push
                    navigationController.pushViewController(controller, animated: animated)
                    completion?()
                } else {
                    controller.navigationSegue = .modal
                    currentViewController.present(UINavigationController(rootViewController: controller), animated: animated, completion: completion)
                }
            case .popover:
                controller.navigationSegue = .popover
                
                // Navigation Controller or not
                let controllerToPresent: UIViewController
                if withNavigationController {
                    controllerToPresent = UINavigationController(rootViewController: controller)
                } else {
                    controllerToPresent = controller
                }
                
                controllerToPresent.modalPresentationStyle = .popover
                
                // Anchor
                if let view = view {
                    controllerToPresent.popoverPresentationController?.sourceView = view
                    controllerToPresent.popoverPresentationController?.sourceRect = view.bounds
                } else if let barButtonItem = barButtonItem {
                    controllerToPresent.popoverPresentationController?.barButtonItem = barButtonItem
                } else {
                    controllerToPresent.popoverPresentationController?.sourceView = currentViewController.view
                    controllerToPresent.popoverPresentationController?.sourceRect = CGRect(x: currentViewController.view.bounds.midX, y: currentViewController.view.bounds.midY, width: 0, height: 0)
                    controllerToPresent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

                }
                
                currentViewController.present(controllerToPresent, animated: animated, completion: completion)
            case .modal:
                controller.navigationSegue = self
                let controllerToPresent = withNavigationController ? UINavigationController(rootViewController: controller) : controller
                controllerToPresent.modalPresentationStyle = controller.modalPresentationStyle
                controllerToPresent.modalTransitionStyle = controller.modalTransitionStyle
                currentViewController.present(controllerToPresent, animated: animated, completion: completion)
            case .modalBlur:
                controller.navigationSegue = .modalBlur
                controller.modalPresentationStyle = .overFullScreen
                controller.view.backgroundColor = UIColor.clear
                controller.view.addBlur()
                currentViewController.present(controller, animated: animated, completion: completion)
            }
        }
    }
    
    public func close<T: UIViewController & NavigationProtocol>(
        _ viewController: T,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            switch self {
            case .modal, .modalBlur, .popover:
                viewController.dismiss(animated: animated, completion: completion)
            case .push:
                if let navigationController = viewController.navigationController {
                    navigationController.popViewController(animated: animated)
                    completion?()
                } else {
                    viewController.dismiss(animated: animated, completion: completion)
                }
            }
        }
    }
}

extension UIViewController {
    fileprivate func getFirstNavigationController() -> UINavigationController? {
        if let navigationController = self.navigationController {
            return navigationController.getFirstNavigationController()
        }
        return self as? UINavigationController
    }
}
