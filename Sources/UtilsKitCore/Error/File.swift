//
//  File.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 04/07/2025.
//

#if canImport(SwiftUI)
import SwiftUI

// Define a public protocol named ErrorLocalized that inherits from the Error protocol
public protocol ErrorLocalized: Error {
	
	// Require a read-only property named errorDescription of type LocalizedStringKey
	// This property provides a localized description of the error
	var errorDescription: LocalizedStringKey { get }
}
#endif
