//
//  Sequence+Decode.swift
//  UtilsKit
//
//  Created by RGMC on 29/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

extension Decodable {
    
    /**
        A convenience method to decode data into a object compliant with `Decodable` protocol
     */
    public static func decode(from data: Any?) throws -> Self? {

        if let data = data, let jsonData = (data as? Data) ?? (try? JSONSerialization.data(withJSONObject: data)) {
            do {
                let object: Self = try JSONDecoder().decode(Self.self, from: jsonData)
                return object
            } catch {
                throw error
            }
        } else {
            return nil
        }
    }
}
