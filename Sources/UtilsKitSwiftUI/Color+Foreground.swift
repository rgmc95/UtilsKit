//
//  Color+Foreground.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import SwiftUI

extension Color {
	
	/// Returns the foreground color (black or white) based on the brightness
	/// of the current color.
	///
	/// - The brightness is calculated using the formula based on the
	///   RGB values of the color, where:
	///   - Red is weighted by 299/1000
	///   - Green is weighted by 587/1000
	///   - Blue is weighted by 114/1000
	///
	/// - Returns: `.black` if the brightness of the color is greater than 0.5,
	///            or `.white` otherwise.
	///
	/// - Note: This method is useful when determining the best contrast color
	///         for text or icons on a given background color.
	public func foregroundColor() -> Color {
		let uiColor = UIColor(self)
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		let brightness = (red * 299 + green * 587 + blue * 114) / 1000
		
		return brightness > 0.5 ? .black : .white
	}
}
