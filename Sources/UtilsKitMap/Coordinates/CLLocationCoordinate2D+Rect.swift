//
//  File.swift
//  
//
//  Created by Michael Coqueret on 21/11/2023.
//

#if canImport(MapKit)
import MapKit

extension Array where Element == CLLocationCoordinate2D {
	
	/// Get rect with all coordinates
	public func getRect() -> MKMapRect {
		guard !self.isEmpty else { return .null }
		
		return self
			.map {
				MKMapRect(origin: MKMapPoint($0),
						  size: MKMapSize(width: 1, height: 1))
			}
			.reduce(MKMapRect.null) {
				$0.union($1)
			}
	}
}
#endif
