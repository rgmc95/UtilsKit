//
//  Sequence+Decode.swift
//  UtilsKit
//
//  Created by RGMC on 29/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import OSLog

extension Decodable {
    
	/**
	A convenience method to decode data into a object compliant with `Decodable` protocol
	*/
	public static func decode(from data: Any?) throws -> Self {
		
		if let data = data,
		   let jsonData = (data as? Data) ?? (try? JSONSerialization.data(withJSONObject: data)) {
			do {
				let object: Self = try JSONDecoder().decode(Self.self, from: jsonData)
				return object
			} catch DecodingError.keyNotFound(let key, let context) {
				Logger.decode.error("Key \"\(key.stringValue)\" not found in \(String(describing: Self.self))")
				throw DecodingError.keyNotFound(key, context)
			} catch DecodingError.valueNotFound(let type, let context) {
				Logger.decode.error("Type \"\(type)\" not found in \(String(describing: Self.self))")
				throw DecodingError.valueNotFound(type, context)
			} catch DecodingError.typeMismatch(let type, let context) {
				Logger.decode.error("\"\(type)\" not match in \(String(describing: Self.self))")
				throw DecodingError.typeMismatch(type, context)
			} catch DecodingError.dataCorrupted(let context) {
				Logger.decode.error("Data corruped in \(String(describing: Self.self))")
				throw DecodingError.dataCorrupted(context)
			} catch let error {
				throw error
			}
		} else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Empty data"))
		}
	}
}
