//
//  File.swift
//  
//
//  Created by Michael Coqueret on 16/02/2024.
//

#if canImport(CoreLocation)
import CoreLocation

extension CLLocationCoordinate2D: Codable, @retroactive Hashable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let longitude = try container.decode(CLLocationDegrees.self)
		let latitude = try container.decode(CLLocationDegrees.self)
		self.init(latitude: latitude, longitude: longitude)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(longitude)
		try container.encode(latitude)
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(latitude)
		hasher.combine(longitude)
	}
}
#endif
