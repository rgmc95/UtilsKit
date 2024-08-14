//
//  CLLocationCoordinate2D+Distance.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 17/01/2022.
//  Copyright © 2022 RGMC. All rights reserved.
//

#if canImport(CoreLocation)
import CoreLocation
import MapKit

extension CLLocationCoordinate2D {
	
	/// Get distance to `coordinate`
	public func getDistance(from coordinate: CLLocationCoordinate2D?) throws -> CLLocationDistance {
		guard let coordinate = coordinate else { throw UnknownCoordinate() }
		
		return CLLocation(latitude: self.latitude,
						  longitude: self.longitude)
			.distance(from: CLLocation(latitude: coordinate.latitude,
									   longitude: coordinate.longitude))
	}
	
	/// Get distance and duration to `coordinate`
	public func getDistanceAndDuration(from coordinate: CLLocationCoordinate2D?) async throws -> (distance: Double,
																								  duration: TimeInterval) {
		guard let coordinate = coordinate else { throw UnknownCoordinate() }
		
		let source = MKPlacemark(coordinate: coordinate)
		let destination = MKPlacemark(coordinate: self)
		
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: source)
		request.destination = MKMapItem(placemark: destination)
		request.transportType = MKDirectionsTransportType.automobile
		request.requestsAlternateRoutes = true
		
		return try await withCheckedThrowingContinuation { continuation in
			MKDirections(request: request).calculate { response, _ in
				guard let route = response?.routes.first else {
					continuation.resume(throwing: UnknownRoute())
					return
				}
				
				continuation.resume(returning: (route.distance, route.expectedTravelTime))
			}
		}
	}
}
#endif
