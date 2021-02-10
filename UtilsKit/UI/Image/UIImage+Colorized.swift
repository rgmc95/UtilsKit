//
//  UIImage+Colorized.swift
//  UtilsKit
//
//  Created by David Douard on 10/02/2021.
//

import UIKit

extension UIImage {

    /**
        color any non transparent pixels of an image with color
     */
    public func colorized(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        let rect = CGRect(origin: CGPoint.zero, size: size)
        color.setFill()
        self.draw(in: rect)
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
}
