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
	
	/// Get address from coordinate
	@available(iOS 13.0.0, *)
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

