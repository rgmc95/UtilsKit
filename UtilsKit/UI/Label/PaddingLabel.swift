//
//  PaddingLabel.swift
//  UtilsKit
//
//  Created by RGMC on 09/11/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

/**
 Label with padding configurable from storyboard
 */
@IBDesignable open class PaddingLabel: UILabel {
    
    // MARK: - Inspectables
    @IBInspectable public var topInset: CGFloat = 0.0
    @IBInspectable public var bottomInset: CGFloat = 0.0
    @IBInspectable public var startInset: CGFloat = 0.0
    @IBInspectable public var endInset: CGFloat = 0.0
    
    // MARK: - Variables
    override open var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize: CGSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += self.topInset + self.bottomInset
        intrinsicSuperViewContentSize.width += self.startInset + self.endInset
        return intrinsicSuperViewContentSize
    }
    
    private var isRightToLeft: Bool {
        UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    private var insets: UIEdgeInsets {
        let leftInset: CGFloat
        let rightInset: CGFloat
        
        if self.isRightToLeft {
            leftInset = self.endInset
            rightInset = self.startInset
        } else {
            leftInset = self.startInset
            rightInset = self.endInset
        }
        
        return UIEdgeInsets(top: self.topInset, left: leftInset, bottom: self.bottomInset, right: rightInset)
    }
    
    // MARK: - Draw
    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.insets))
    }
    
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        super.textRect(forBounds: bounds.inset(by: self.insets), limitedToNumberOfLines: numberOfLines)
    }
}
