//
//  CLLocationCoordinate2D+Route.swift
//
//
//  Created by Michael Coqueret on 21/11/2023.
//

#if canImport(MapKit)
import Foundation
import MapKit

extension CLLocationCoordinate2D {
	
	/// Get route to coordinate
	public func getRoute(from coordinate: CLLocationCoordinate2D) async throws -> MKPolyline {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate,
														  addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self,
															   addressDictionary: nil))
		request.requestsAlternateRoutes = true
		request.transportType = .automobile
		
		let directions = MKDirections(request: request)
		
		return try await withUnsafeThrowingContinuation { continuation in
			directions.calculate { response, error in
				if let error = error {
					continuation.resume(throwing: error)
					return
				}
				
				guard let route = response?.routes.first else {
					continuation.resume(throwing: UnknownRoute())
					return
				}
				
				continuation.resume(returning: route.polyline)
			}
		}
	}
}

extension Array where Element == CLLocationCoordinate2D {
	
	/// Get routes between coordinates
	public func getRoutes() async -> [MKPolyline] {
		var routes: [MKPolyline?] = []
		
		guard var current = self.first else { return [] }
		
		for coordinate in Array(self.suffix(from: 1)) {
			let value = try? await coordinate.getRoute(from: current)
			routes.append(value)
			
			current = coordinate
		}
		
		return routes.compactMap { $0 }
	}
}
#endif
