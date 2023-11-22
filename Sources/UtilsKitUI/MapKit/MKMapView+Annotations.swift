//
//  MKMapView+Annotations.swift
//
//
//  Created by Michael Coqueret on 21/11/2023.
//

#if canImport(MapKit)
import MapKit

extension MKMapView {
	
	/// Get all visibile annotations
	public func visibleAnnotations() -> [MKAnnotation] {
		self.annotations(in: self.visibleMapRect).compactMap { $0 as? MKAnnotation }
	}
	
	/// Show all visibile annotations with inset
	public func showAnnotations(_ annotations: [MKAnnotation], inset: UIEdgeInsets, animated: Bool) {
		let rect = annotations.map { $0.coordinate }.getRect()
		self.setVisibleMapRect(rect,
							   edgePadding: inset,
							   animated: animated)
	}
}
#endif
