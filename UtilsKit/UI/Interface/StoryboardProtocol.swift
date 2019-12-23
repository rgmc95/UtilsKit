//
//  StoryboardProtocol.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

/**
 
 This protocol provides easy initilization for view controllers from storyboards.
 
 To make a view controller compliant with this protocol, implement:
 
 - storyboardName: name of the storyboard.
 - identifier: identifier of the view controller if set.
 
 If the identifier is not set, it assumes that the view controller is the initial view controller.
 
 */
public protocol StoryboardProtocol: class {
    static var storyboardName: String {get}
    static var identifier: String? {get}
}

extension StoryboardProtocol {
    public static var identifier: String? { return nil }
    
    /**
    
    Initialize the view controller from the storyboard.
     
     - parameter infos: a closure taking as parameter the initialized view controller. It can be used to set custom values upon initialization.
     
     - returns: the view controller initialized or nil.
     
    */
    public static func fromStoryboard(_ infos: ((Self) -> Void)? = nil) -> Self {
        let controller: Self
        if let identifier = Self.identifier {
            controller = UIStoryboard(name: Self.storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
        } else {
            controller = UIStoryboard(name: Self.storyboardName, bundle: nil).instantiateInitialViewController() as! Self
        }
        
        infos?(controller)
        
        return controller
    }
}
