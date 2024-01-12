//
//  MKMapView+ZoomLevel.swift
//
//
//  Created by Michael Coqueret on 30/11/2023.
//

#if canImport(MapKit)
import Foundation
import MapKit

extension MKMapView {
	
	/// Current zoom level
	public var zoomLevel: Int {
		Int(log2(360 * (Double(self.frame.size.width / 256) / self.region.span.longitudeDelta)))
	}
	
	private func getDelta(for zoomLevel: Int) -> MKCoordinateSpan {
		MKCoordinateSpan(latitudeDelta: 0,
						 longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
	}
	
	// Set center in coordinate with zoom and inset
	public func setCenter(coordinate: CLLocationCoordinate2D,
				   zoomLevel: Int?,
				   inset: UIEdgeInsets = .zero,
				   animated: Bool = true) {
		let span = zoomLevel == nil ? region.span : self.getDelta(for: zoomLevel ?? 0)
		let region = MKCoordinateRegion(center: coordinate,
										span: span)
		
		self.setVisibleMapRect(region.getRect(),
							   edgePadding: inset,
							   animated: animated)
	}
}
#endif
