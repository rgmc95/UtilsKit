//
//  CGFloat+Operator.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

/**
    Make a class compliant with this protocol to transform it into a `CGFloat` and use custom operators provided (* and /).
 */
public protocol CGFloatConvertor {
    /**
     `CGFloat` representation of the class implementing this method.
     
     - returns: a `CGFloat` value.
     */
    func toCGFloat() -> CGFloat
}

extension Int: CGFloatConvertor {
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension Float: CGFloatConvertor {
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension Double: CGFloatConvertor {
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension UInt64: CGFloatConvertor {
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    /**
     Multiply a `CGFloatConvertor` and a `CGFloat`.
     
     - parameter lhs: left member `CGFloatConvertor`
     
     - parameter rhs: right member `CGFloat`
     
     - returns: the result of the multiplication.
     */
    public static func * (left: CGFloatConvertor, right: CGFloat) -> CGFloat {
        return left.toCGFloat() * right
    }
    
    /**
     Multiply a `CGFloatConvertor` and a `CGFloat`.
     
     - parameter lhs: left member `CGFloat`
     
     - parameter rhs: right member `CGFloatConvertor`
     
     - returns: the result of the multiplication.
     */
    public static func * (left: CGFloat, right: CGFloatConvertor) -> CGFloat {
        return right.toCGFloat() * left
    }
    
    /**
     Divide a `CGFloatConvertor` and a `CGFloat`.
     
     - parameter lhs: left member `CGFloatConvertor`
     
     - parameter rhs: right member `CGFloat`
     
     - returns: the result of the division.
     */
    public static func / (left: CGFloatConvertor, right: CGFloat) -> CGFloat {
        return left.toCGFloat() / right
    }
    
    /**
     Divide a `CGFloatConvertor` and a `CGFloat`.
     
     - parameter lhs: left member `CGFloat`
     
     - parameter rhs: right member `CGFloatConvertor`
     
     - returns: the result of the division.
     */
    public static func / (left: CGFloat, right: CGFloatConvertor) -> CGFloat {
        return  left / right.toCGFloat()
    }
    
}
