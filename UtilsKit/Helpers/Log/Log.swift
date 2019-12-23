//
//  Log.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

/**
 Network Log type.
 */
public enum NetworkLogType {
    case sending
    case success
    case error
    
    public var prefix: String {
        switch self {
        case .sending: return "➡️"
        case .success: return "✅"
        case .error: return "❌"
        }
    }
}

/**
    Log type.
 */
public enum LogType {
    case network(method: String, type: NetworkLogType)
    case data
    case coredata
    case file
    case login
    case secure
    case notification
    case camera
    case photo
    case biometry
    case tag
    case refresh
    case map
    case spotlight
    case debug
    case custom(String)
    
    public var prefix: String {
        switch self {
        case .network(let method, let type): return "🌍 \(method) \(type.prefix)"
        case .data: return "🗄"
        case .coredata: return "💾"
        case .file: return "📃"
        case .secure: return "🗝"
        case .login: return "👤"
        case .notification: return "🛎"
        case .camera: return "📹"
        case .photo: return "📷"
        case .biometry: return "🛡"
        case .tag: return "🏷"
        case .refresh: return "🔄"
        case .map: return "🗺"
        case .spotlight: return "🔍"
        case .debug: return "🕹"
        case .custom(let prefix): return prefix
        }
    }
}

fileprivate var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
    return dateFormatter
}()

/**
 
    Print a custom log, usually prefixed with an unicode character.
 
    Use LogType which provides default prefixes to print custom prefixes.
 
    Passing an error to this method results in printing its localized description.
 
    - parameter type: type of the log, compliant with `LogProtocol` protocol.
    - parameter message: message to print.
    - parameter error: error to print localized description.
 
 */
public func log(_ type: LogType = .debug, _ message: String? = nil) {
    #if DEBUG
    print("\(dateFormatter.string(from: Date())) ~ \(type.prefix) - \(message ?? "")")
    #endif
}

public func log(_ type: LogType = .debug, _ message: String? = nil, error: Error?) {
    #if DEBUG
    var message = "\(dateFormatter.string(from: Date())) ~ \(type.prefix) - \(message ?? "")"
    
    if let error = error {
        message += " 🛑 \(error)"
    }
    print(message)
    #endif
}

