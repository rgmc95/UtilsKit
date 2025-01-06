//
//  MKLocalSearchCompletion+Coordinate..swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

#if canImport(MapKit)
import MapKit
import UtilsKitHelpers

extension MKLocalSearchCompletion: @retroactive Identifiable {
	
	/// A unique identifier for the search completion based on its title and subtitle.
	/// This property conforms to the `Identifiable` protocol.
	public var id: String {
		[self.title, self.subtitle].joined(separator: "\n")
	}
	
	/// An asynchronous property that retrieves the coordinate of the location associated
	/// with the search completion.
	///
	/// This uses the `MKLocalSearch` API to perform a search request based on the completion,
	/// and resolves the location's coordinate if available. In case of failure, an error is thrown.
	///
	/// - Returns: A `CLLocationCoordinate2D` representing the geographic coordinate of the location.
	/// - Throws: An error of type `UnknownCoordinate` if the coordinate cannot be resolved.
	public var coordinate: CLLocationCoordinate2D {
		get async throws {
			let request = MKLocalSearch.Request(completion: self)
			let search = MKLocalSearch(request: request)
			
			return try await withCheckedThrowingContinuation { continuation in
				search.start { response, error in
					if let error {
						continuation.resume(throwing: error)
						return
					}
					
					guard let response = response else {
						continuation.resume(throwing: UnknownCoordinate())
						return
					}
					
					for item in response.mapItems {
						if let location = item.placemark.location {
							continuation.resume(returning: location.coordinate)
							return
						}
					}
					
					continuation.resume(throwing: UnknownCoordinate())
				}
			}
		}
	}
}
#endif
