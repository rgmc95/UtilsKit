//
//  UIImage+TintColorable.swift
//  UtilsKit
//
//  Created by RGMC on 05/04/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

extension UIButton {
    
    /**
        Set the image colorated with given color.
     
        - parameter image: image
        - parameter color: color of the image
     */
    public func setImage(_ image: UIImage, withColor color: UIColor, for state: UIControl.State) {
        self.setImage(image.withRenderingMode(.alwaysTemplate), for: state)
        
        switch buttonType {
        case .custom:
            self.imageView?.tintColor = color
        default:
            self.tintColor = color
        }
    }
}

extension UIImageView {
    
    /**
     Set the image colorated with given color.
     
     - parameter image: image
     - parameter color: color of the image
     */
    public func setImage(_ image: UIImage, withColor color: UIColor) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
