//
//  URL+Image.swift
//  Trivel
//
//  Created by Michael Coqueret on 04/02/2025.
//  Copyright © 2025 Trivel. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

extension URL {
	
	/**
	 Asynchronously retrieves an image from the URL and returns it as JPEG data.
	 
	 This method fetches an image from the URL, converts it to JPEG data with the specified compression quality, and returns the data. If the image cannot be fetched or converted, it returns `nil`.
	 
	 - Parameter compressionQuality: The quality of the JPEG image representation as a value between 0 and 1. The default value is 0.1.
	 
	 - Returns: A `Data` object containing the JPEG representation of the image, or `nil` if the image could not be fetched or converted.
	 */
	public func getImage(compressionQuality: CGFloat = 0.1) async -> Data? {
		await withCheckedContinuation { continuation in
			Task {
				guard let image = try? await self.toImage() else {
					return continuation.resume(returning: nil)
				}
				
				let imageData = image.jpegData(compressionQuality: compressionQuality)
				continuation.resume(returning: imageData)
			}
		}
	}
	
	private func toImage() async throws -> UIImage? {
		var request = URLRequest(url: self)
		request.cachePolicy = .reloadIgnoringLocalCacheData
		let (data, _) = try await URLSession.shared.data(for: request)
		return UIImage(data: data)
	}
}
#endif
