//
//  Dictionnary+Operator.swift
//  UtilsKit
//
//  Created by RGMC on 29/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

/**
    Concat the right member dictionnary into the left one.
 
    Existing key is replaced.
 */
public func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
