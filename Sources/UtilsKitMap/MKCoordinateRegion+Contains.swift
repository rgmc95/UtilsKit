//
//  MKCoordinateRegion+Contains.swift
//
//
//  Created by Michael Coqueret on 12/01/2024.
//

#if canImport(MapKit)
import MapKit

public extension MKCoordinateRegion {
	
	/// `true` if region contains coordinate
	func contains(coordinate: CLLocationCoordinate2D) -> Bool {
		cos((center.latitude - coordinate.latitude) * Double.pi / 180) > cos(span.latitudeDelta / 2.0 * Double.pi / 180) &&
		cos((center.longitude - coordinate.longitude) * Double.pi / 180) > cos(span.longitudeDelta / 2.0 * Double.pi / 180)
	}
}
#endif
