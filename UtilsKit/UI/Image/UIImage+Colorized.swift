//
//  UIImage+Colorized.swift
//  UtilsKit
//
//  Created by David Douard on 10/02/2021.
//

import UIKit

extension UIImage {

    /**
        Color any non transparent pixels of an image with color
     */
    public func colorized(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
        let rect = CGRect(origin: CGPoint.zero, size: size)
        color.setFill()
        self.draw(in: rect)
        context.setBlendMode(.sourceIn)
        context.fill(rect)
		
		guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return resultImage
    }
}
