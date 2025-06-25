//
//  CLLocationCoordinate2D+Address.swift
//
//
//  Created by Michael Coqueret on 21/11/2023.
//

#if canImport(CoreLocation)
import CoreLocation
import Contacts

extension CLLocationCoordinate2D {
	
	/// Init Coordinate from address
	public init(from address: String) async throws {
		let location =
		try await withCheckedThrowingContinuation { (continuation: _Concurrency.CheckedContinuation<CLLocation, Error>) in
			CLGeocoder().geocodeAddressString(address) { placemarks, error in
				if let error {
					continuation.resume(throwing: error)
					return
				}
				
				guard let placemarks, let location = placemarks.first?.location else {
					continuation.resume(throwing: UnknownAddress())
					return
				}
				
				continuation.resume(returning: location)
			}
		}
		
		self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
	}
	
	/// Get address from coordinate
	public func getAddress() async throws -> CNPostalAddress {
		
		let latitude = self.latitude
		let longitude = self.longitude
		let location = CLLocation(latitude: latitude, longitude: longitude)
		
		return try await withCheckedThrowingContinuation { continuation in
			CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ -> Void in
				var pm: CLPlacemark!
				pm = placemarks?[0]
				
				if let value = pm.postalAddress {
					continuation.resume(returning: value)
				} else {
					continuation.resume(throwing: UnknownCoordinate())
				}
			}
		}
	}
}
#endif

