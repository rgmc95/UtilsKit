//
//  Identifiable.swift
//  UtilsKit
//
//  Created by RGMC on 18/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

/**
 Make an object identifiable
 */
public protocol Identifiable {
    var identifier: ObjectIdentifier {get}
    func isEqualTo(_ identifiable: Identifiable) -> Bool
}

extension Identifiable {
    /**
     Check the equality of two identifiables
     */
    public func isEqualTo(_ identifiable: Identifiable) -> Bool {
        return self.identifier == identifiable.identifier
    }
}
