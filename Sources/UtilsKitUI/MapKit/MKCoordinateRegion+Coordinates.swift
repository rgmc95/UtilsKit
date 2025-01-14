//
//  MKCoordinateRegion+Coordinates.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import MapKit

extension MKCoordinateRegion {
	
	/// Initializes a new `MKCoordinateRegion` that encompasses the provided coordinates.
	///
	/// - Parameter coordinates: An array of `CLLocationCoordinate2D` representing the points to include in the region.
	///
	/// If the array contains a single coordinate, the region is centered on that point with a default span of 0.005 for both latitude and longitude.
	///
	/// If the array contains multiple coordinates, the region is calculated to fit all points with a small padding.
	/// The span is slightly increased by 20% to ensure all points are comfortably visible within the region.
	///
	/// If the array is empty, a default `MKCoordinateRegion` is created.
	///
	/// - Example usage:
	/// ```swift
	/// let coordinates = [
	///     CLLocationCoordinate2D(latitude: 48.8588443, longitude: 2.2943506), // Eiffel Tower
	///     CLLocationCoordinate2D(latitude: 40.689247, longitude: -74.044502), // Statue of Liberty
	/// ]
	///
	/// let region = MKCoordinateRegion(coordinates: coordinates)
	/// ```
	public init(coordinates: [CLLocationCoordinate2D], multiplier: Double = 1.6) {
		if coordinates.count == 1, let coordinate = coordinates.first {
			self = .init(center: coordinate, span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005))
			return
		}
		
		guard
			!coordinates.isEmpty,
			let minLat = coordinates.map(\.latitude).min(),
			let minLon = coordinates.map(\.longitude).min(),
			let maxLat = coordinates.map(\.latitude).max(),
			let maxLon = coordinates.map(\.longitude).max()
		else {
			self = .init()
			return
		}
		
		let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
		
		let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * multiplier, longitudeDelta: (maxLon - minLon) * multiplier)
		self = MKCoordinateRegion(center: center, span: span)
	}
}
