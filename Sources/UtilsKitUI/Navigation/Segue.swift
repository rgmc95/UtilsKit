//
//  Segue.swift
//  UtilsKit
//
//  Created by RGMC on 15/06/2020.
//  Copyright © 2020 RGMC. All rights reserved.
//

import Foundation
import UIKit
import OSLog

#if canImport(UtilsKitCore)
import UtilsKitCore
#endif

/**
 
 Styles of the navigation.
 
 Navigation styles provided:
 
 - push
 - modal
 - modalBlur
 
 */
@available(iOSApplicationExtension, introduced: 1.0, unavailable)
public enum Segue {
	
	/// Push on current navigation controller
	case push
	
	/// Present
	case modal
	
	/// Present with blur background
	case modalBlur
	
	/// Popover
	case popover
	
	/// Popover from view
	case popoverView(UIView)
	
	/// Popover from bar button item
	case popoverBarButton(UIBarButtonItem)
	
	/**
	 Present a view controller
	 - parameter controller: Controller to present
	 - parameter currentViewController: Current view controller
	 - parameter withNavigationController: Add a navigation controller
	 - parameter animated: Animate present
	 
	 */
	@MainActor
	public func present<T: UIViewController & NavigationProtocol>(_ controller: T?,
																  from currentViewController: UIViewController? = nil,
																  withNavigationController: Bool = false,
																  animated: Bool = true,
																  completion: (() -> Void)? = nil) {
		
		// Check controller & current controller
		guard
			let controller = controller,
			let currentViewController = currentViewController ?? UIApplication.shared.topViewController(segue: self)
		else { return }
		
		if let _currentViewController = currentViewController as? NavigationProtocol {
			switch self {
			case .push:
				_currentViewController.viewWillPresent(controller: controller) {
					self._present(controller,
								  from: currentViewController,
								  withNavigationController: withNavigationController,
								  animated: animated,
								  completion: completion)
				}
				return
				
			default:
				if controller.isModalFullScreen {
					_currentViewController.viewWillPresent(controller: controller) {
						self._present(controller,
									  from: currentViewController,
									  withNavigationController: withNavigationController,
									  animated: animated,
									  completion: completion)
					}
					return
				}
			}
		}
		
		self._present(controller,
					  from: currentViewController,
					  withNavigationController: withNavigationController,
					  animated: animated,
					  completion: completion)
	}
	
	@MainActor
	private func _present<T: UIViewController & NavigationProtocol>(_ controller: T,
																  from currentViewController: UIViewController,
																  withNavigationController: Bool = false,
																  animated: Bool = true,
																  completion: (() -> Void)? = nil) {
		
		// If controller to show is current controller, do nothing
		var controller = controller
		
		if
			let currentViewController: T = currentViewController as? T,
			let currentIdentifier: String = currentViewController.instanceIdentifier,
			let controllerIdentifier: String = controller.instanceIdentifier,
			controllerIdentifier == currentIdentifier
		{
			return
		}
		
		if let _ = UIApplication.shared.topAlertView {
			Logger.navigation.fault("Push \(controller) - \(NavigationError.pushOnAlertController.localizedDescription)")
			return
		}
		
		// Set previous controller
		controller.previousViewController = currentViewController
		controller.navigationSegue = self
		
		switch self {
		case .push:
			self.push(controller,
					  from: currentViewController,
					  animated: animated,
					  completion: completion)
			
		case .popover:
			self.popover(controller,
						 from: currentViewController,
						 withNavigationController: withNavigationController,
						 animated: animated,
						 completion: completion)
			
		case .popoverView(let view):
			self.popover(controller,
						 from: currentViewController,
						 from: view,
						 withNavigationController: withNavigationController,
						 animated: animated,
						 completion: completion)
			
		case .popoverBarButton(let button):
			self.popover(controller,
						 from: currentViewController,
						 from: button,
						 withNavigationController: withNavigationController,
						 animated: animated,
						 completion: completion)
			
		case .modal:
			self.modal(controller,
					   from: currentViewController,
					   withNavigationController: withNavigationController,
					   animated: animated,
					   completion: completion)
			
		case .modalBlur:
			controller.modalPresentationStyle = .overFullScreen
			controller.view.backgroundColor = UIColor.clear
			controller.view.addBlur()
			
			currentViewController.present(controller, animated: animated, completion: completion)
		}
	}
	
	@MainActor
	private func push<T: UIViewController & NavigationProtocol>(_ controller: T,
																from currentViewController: UIViewController,
																animated: Bool = true,
																completion: (() -> Void)? = nil) {
		
		if let navigationController: UINavigationController = (currentViewController as? UINavigationController)
			?? currentViewController.navigationController {
			navigationController.pushViewController(controller, animated: animated)
			completion?()
		} else {
			Logger.navigation.fault("Push \(controller) - \(NavigationError.pushWithoutNavigationController.localizedDescription)")
		}
	}
	
	@MainActor
	private func modal<T: UIViewController & NavigationProtocol>(_ controller: T,
																 from currentViewController: UIViewController,
																 withNavigationController: Bool = false,
																 animated: Bool = true,
																 completion: (() -> Void)? = nil) {
		
		let controllerToPresent: UIViewController = controller.embedInNavigationController(withNavigationController)
		controllerToPresent.modalPresentationStyle = controller.modalPresentationStyle
		controllerToPresent.modalTransitionStyle = controller.modalTransitionStyle
		
		if #available(iOS 15.0, *) {
			if let sheet = controller.sheetPresentationController {
				controllerToPresent.sheetPresentationController?.detents = sheet.detents
				controllerToPresent.sheetPresentationController?.selectedDetentIdentifier = sheet.selectedDetentIdentifier
				controllerToPresent.sheetPresentationController?.largestUndimmedDetentIdentifier = sheet.largestUndimmedDetentIdentifier
				controllerToPresent.sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = sheet.prefersScrollingExpandsWhenScrolledToEdge
				controllerToPresent.sheetPresentationController?.prefersGrabberVisible = sheet.prefersGrabberVisible
			}
		}
		
		currentViewController.present(controllerToPresent, animated: animated, completion: completion)
	}
	
	@MainActor
	private func popover<T: UIViewController & NavigationProtocol>(_ controller: T,
																   from currentViewController: UIViewController,
																   withNavigationController: Bool = false,
																   animated: Bool = true,
																   completion: (() -> Void)? = nil) {
		
		let controllerToPresent: UIViewController = controller.embedInNavigationController(withNavigationController)
		controllerToPresent.modalPresentationStyle = .popover
		controllerToPresent.popoverPresentationController?.sourceView = currentViewController.view
		controllerToPresent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		controllerToPresent.popoverPresentationController?.sourceRect = CGRect(x: currentViewController.view.bounds.midX,
																			   y: currentViewController.view.bounds.midY,
																			   width: 0,
																			   height: 0)
		
		currentViewController.present(controllerToPresent, animated: animated, completion: completion)
	}
	
	@MainActor
	private func popover<T: UIViewController & NavigationProtocol>(_ controller: T,
																   from currentViewController: UIViewController,
																   from button: UIBarButtonItem,
																   withNavigationController: Bool = false,
																   animated: Bool = true,
																   completion: (() -> Void)? = nil) {
		
		let controllerToPresent: UIViewController = controller.embedInNavigationController(withNavigationController)
		controllerToPresent.modalPresentationStyle = .popover
		controllerToPresent.popoverPresentationController?.barButtonItem = button
		controllerToPresent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		
		currentViewController.present(controllerToPresent, animated: animated, completion: completion)
	}
	
	@MainActor
	private func popover<T: UIViewController & NavigationProtocol>(_ controller: T,
																   from currentViewController: UIViewController,
																   from view: UIView,
																   withNavigationController: Bool = false,
																   animated: Bool = true,
																   completion: (() -> Void)? = nil) {
		
		let controllerToPresent: UIViewController = controller.embedInNavigationController(withNavigationController)
		controllerToPresent.modalPresentationStyle = .popover
		controllerToPresent.popoverPresentationController?.sourceView = view
		controllerToPresent.popoverPresentationController?.sourceRect = view.bounds
		
		currentViewController.present(controllerToPresent, animated: animated, completion: completion)
	}
	
	/**
	 Close view controller
	 */
	@MainActor
	public func close<T: UIViewController & NavigationProtocol>(_ viewController: T,
																animated: Bool = true,
																completion: (() -> Void)? = nil) {
		switch self {
		case .modal, .modalBlur, .popover, .popoverView, .popoverBarButton:
			viewController.dismiss(animated: animated, completion: completion)
			
		case .push:
			if let navigationController: UINavigationController = viewController.navigationController {
				navigationController.popViewController(animated: animated)
				completion?()
			} else {
				viewController.dismiss(animated: animated, completion: completion)
			}
		}
	}
}

@available(iOSApplicationExtension, introduced: 1.0, unavailable)
extension Segue: Equatable {
	
	public static func == (lhs: Segue, rhs: Segue) -> Bool {
		false
	}
}

private extension UIViewController {
	
	var isModalFullScreen: Bool {
		if #available(iOS 13.0, *) {
			return self.isModalInPresentation
		} else {
			return true
		}
	}
	
	func embedInNavigationController(_ value: Bool) -> UIViewController {
		if !(self is UINavigationController) && value {
			return RGMCNavigationController(rootViewController: self)
		} else {
			return self
		}
	}
}
