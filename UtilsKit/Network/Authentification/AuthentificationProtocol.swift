//
//  AuthentificationProtocol.swift
//  UtilsKit
//
//  Created by RGMC on 18/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

public protocol AuthentificationProtocol {
    var parameters: [String: String] {get}
    var encoding: AuthentificationEncoding {get}
}


public enum AuthentificationEncoding {
    case header
    case body
    case url
}
