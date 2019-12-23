//
//  AlertManager.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

/**
    Represent an action for an alert controller.
 */
public struct AlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let completion: (()->Void)?

    public init(title: String, style: UIAlertAction.Style, completion: (()->Void)? = nil) {
        self.title = title
        self.style = style
        self.completion = completion
    }
}

/**
    Manage alert controllers with a single method `show`.
 */
public struct AlertManager {
    
    //MARK: Singleton
    public static var shared: AlertManager = AlertManager()
    
    /**
        Show an alert controller on top of the navigation stack.
     
        - parameter title: title of the alert.
        - parameter message: message of the alert.
        - parameter alignment: alignment of the message.
        - parameter preferredStyle: controller style.
        - parameter actions: list of actions.
     */
    public func show(title: String? = nil,
              message: String? = nil,
              alignment: NSTextAlignment = .center,
              preferredStyle: UIAlertController.Style = .alert,
              actions: [AlertAction]) {
        DispatchQueue.main.async {
            guard let currenViewController = UIApplication._shared?.topViewController else { return }
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: preferredStyle)
            
            for action in actions {
                let actionButton = UIAlertAction(title: action.title, style: action.style, handler: { (alertAction) in
                    action.completion?()
                })
                alertController.addAction(actionButton)
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            
            let messageText = NSMutableAttributedString(
                string: message ?? "",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                ]
            )
            
            alertController.setValue(messageText, forKey: "attributedMessage")
            
            currenViewController.present(alertController, animated: true)
            
        }
    }
    
    /**
        Show a default error alert controller on top of the navigation stack.
        The title of the alert controller is the localized description of the error.
     
        - parameter error: error to be printed.
     */
    public func show(_ error: Error) {
        self.show(title: error.localizedDescription, actions: [AlertAction(title: "OK", style: .cancel)])
    }
}


