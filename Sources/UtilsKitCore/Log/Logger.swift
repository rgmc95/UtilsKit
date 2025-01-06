//
//  File.swift
//  
//
//  Created by Michael Coqueret on 14/08/2024.
//

import OSLog

public extension Logger {
		
	static let data 		= Logger(subsystem: "UtilsKit", category: "Data")
	static let decode 		= Logger(subsystem: "UtilsKit", category: "Decode")
	static let biometry 	= Logger(subsystem: "UtilsKit", category: "Biometry")
	static let file 		= Logger(subsystem: "UtilsKit", category: "File")
	static let navigation 	= Logger(subsystem: "UtilsKit", category: "Navigation")
	static let string 		= Logger(subsystem: "UtilsKit", category: "String")
	static let device 		= Logger(subsystem: "UtilsKit", category: "Device")
}

