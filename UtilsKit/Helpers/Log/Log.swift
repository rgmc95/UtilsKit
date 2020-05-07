//
//  Log.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

/**
 
    Print a custom log, usually prefixed with an unicode character.
 
    Use LogType which provides default prefixes to print custom prefixes.
 
    Passing an error to this method results in printing its localized description.
 
    - parameter type: type of the log, compliant with `LogType` protocol.
    - parameter message: message to print.
    - parameter error: error to print localized description.
 
 */
public func log(_ type: LogType, _ message: String? = nil, error: Error? = nil) {
    showLog(type, message, error: error)
}

/**
 
    Print a custom log, usually prefixed with an unicode character.
 
    Use LogType which provides default prefixes to print custom prefixes.
 
    Passing an error to this method results in printing its localized description.
 
    - parameter type: Internal type of the log,
    - parameter message: message to print.
    - parameter error: error to print localized description.
 
 */
public func log(_ type: DefaultLogType = .debug, _ message: String? = nil, error: Error? = nil) {
    showLog(type, message, error: error)
}

private func showLog(_ type: LogType, _ message: String? = nil, error: Error? = nil) {
    #if DEBUG
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
    
    var message: String = "\(dateFormatter.string(from: Date())) ~ \(type.prefix) - \(message ?? "")"
    
    if let error: Error = error {
        message += " 🛑 \(error)"
    }
    print(message)
    #endif
}
