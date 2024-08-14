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
	
	init(system: String, object: Any) {
		self.init(subsystem: system, category: String(describing: object))
	}
	
	func notice(message: String) {
		self.notice("\(message)")
	}
	
	func info(message: String) {
		self.info("\(message)")
	}
	
	func debug(message: String) {
		self.debug("\(message)")
	}
	
	func trace(message: String) {
		self.trace("\(message)")
	}

	func warning(message: String) {
		self.warning("\(message)")
	}
	
	func error(message: String) {
		self.error("\(message)")
	}
	
	func fault(object: Any, error: Error? = nil) {
		self.fault(message: "\(object)", error: error)
	}
	
	func fault(message: String, error: Error? = nil) {
		if let error {
			self.fault("\(message) - \(error.localizedDescription)")
		} else {
			self.fault("\(message)")
		}
	}
	
	func critical(message: String) {
		self.critical("\(message)")
	}
}

