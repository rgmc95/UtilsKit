//
//  NibProtocol.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

/**
 
 This protocol provides easy initialization for view from nib files with the method `fromNib()`.
 
 To make a view compliant with this protocol, implement:
 
 - nibName: name of the nib. Default class name
 
*/
public protocol NibProtocol: AnyObject {
    
    static var nibName: String? { get }
}

extension NibProtocol {
    
    /// Name of the nib to instantiate
    public static var nibName: String? { String(describing: Self.self) }
}

extension NibProtocol {
    
    /**
     
    This method initializes the view from its nib file.
     
    - returns: The view initialized or nil.
     
    */
    public static func fromNib() -> Self {
        guard let nibName = Self.nibName else {
            fatalError("Unknown nib name")
        }
        let nibs = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil) ?? []
        for nib in nibs {
            if let view: Self = nib as? Self { return view }
         }
        fatalError("Cannot find class in nib named \(nibName)")
    }
}

extension UIView {
    
    /**
     Setup view when declared in interface builder
     */
    public func xibSetup() {
        let view: Self = loadFromNib()
        addSubview(view)
        stretch(view: view)
    }
    
    private func loadFromNib<T: UIView>() -> T {
        let nibName = String(describing: type(of: self))
        let nibs = UINib(nibName: nibName, bundle: Bundle.main).instantiate(withOwner: self, options: nil)
        
        for nib in nibs {
            if let view: T = nib as? T { return view }
        }
        
        fatalError("Cannot find class in nib named \(nibName)")
    }
    
    func stretch(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leftAnchor.constraint(equalTo: leftAnchor),
                view.rightAnchor.constraint(equalTo: rightAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
}
