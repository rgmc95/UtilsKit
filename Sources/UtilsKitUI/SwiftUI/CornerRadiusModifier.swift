//
//  CornerRadiusModifier.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import SwiftUI

@available(iOS 16.0, *)
private struct CornerRadiusModifier: ViewModifier {
	
	let radius: RectangleCornerRadii
	let borderColor: Color
	let borderWidth: CGFloat
	let backgroundColor: Color
	
	func body(content: Content) -> some View {
		content
			.background {
				UnevenRoundedRectangle(cornerRadii: radius)
					.fill(self.backgroundColor)
			}
			.background {
				UnevenRoundedRectangle(cornerRadii: radius)
					.stroke(self.borderColor, lineWidth: self.borderWidth)
			}
	}
}

@available(iOS 16.0, *)
extension View {
	
	/// Applies a corner radius with optional border and background colors to a view.
	///
	/// This method rounds all four corners of the view with the specified radius and allows customization of the border and background colors.
	///
	/// - Parameters:
	///   - radius: The radius to apply to all corners. Default is `0`.
	///   - borderColor: The color of the border around the view. Default is `.clear`.
	///   - backgroundColor: The background color of the view. Default is `.clear`.
	/// - Returns: A view with rounded corners, a border, and a background color.
	///
	/// ### Example Usage
	/// ```swift
	/// Text("Hello, World!")
	///     .cornerRadius(10, borderColor: .blue, backgroundColor: .yellow)
	/// ```
	///
	/// In this example, the corners of the text are rounded with a radius of 10, the border is blue, and the background is yellow.
	public func cornerRadius(_ radius: CGFloat, borderColor: Color = .clear, borderWidth: CGFloat = 1, backgroundColor: Color = .clear) -> some View {
		ModifiedContent(content: self,
						modifier: CornerRadiusModifier(radius: RectangleCornerRadii(topLeading: radius,
																					bottomLeading: radius,
																					bottomTrailing: radius,
																					topTrailing: radius),
													   borderColor: borderColor,
													   borderWidth: borderWidth,
													   backgroundColor: backgroundColor))
	}
	
	/// Applies custom corner radii to each corner of a view with optional border and background colors.
	///
	/// This method allows you to set different radii for each corner, and it also allows customizing the border and background colors.
	///
	/// - Parameters:
	///   - topLeading: The radius to apply to the top-left corner. Default is `0`.
	///   - topTrailing: The radius to apply to the top-right corner. Default is `0`.
	///   - bottomLeading: The radius to apply to the bottom-left corner. Default is `0`.
	///   - bottomTrailing: The radius to apply to the bottom-right corner. Default is `0`.
	///   - borderColor: The color of the border around the view. Default is `.clear`.
	///   - backgroundColor: The background color of the view. Default is `.clear`.
	/// - Returns: A view with custom rounded corners, a border, and a background color.
	///
	/// ### Example Usage
	/// ```swift
	/// Text("Custom Corners")
	///     .cornerRadius(topLeading: 10, topTrailing: 20, bottomLeading: 30, bottomTrailing: 40, borderColor: .green, backgroundColor: .gray)
	/// ```
	///
	/// In this example, each corner of the text is rounded with a different radius, the border is green, and the background is gray.
	public func cornerRadius(topLeading: CGFloat = 0,
							 topTrailing: CGFloat = 0,
							 bottomLeading: CGFloat = 0,
							 bottomTrailing: CGFloat = 0,
							 borderColor: Color = .clear,
							 borderWidth: CGFloat = 1,
							 backgroundColor: Color = .clear) -> some View {
		ModifiedContent(content: self,
						modifier: CornerRadiusModifier(radius: RectangleCornerRadii(topLeading: topLeading,
																					bottomLeading: bottomLeading,
																					bottomTrailing: bottomTrailing,
																					topTrailing: topTrailing),
													   borderColor: borderColor,
													   borderWidth: borderWidth,
													   backgroundColor: backgroundColor))
	}
}


@available(iOS 16.0, *)
#Preview {
	VStack {
		Text("Test")
			.padding()
			.cornerRadius(borderColor: .red)
		
		Text("Test")
			.padding()
			.cornerRadius(topLeading: 12, borderColor: .green)
		
		Text("Test")
			.padding()
			.cornerRadius(topLeading: 12, borderColor: .red, borderWidth: 4, backgroundColor: .blue)
		
		Text("Test")
			.padding()
			.cornerRadius(12, borderColor: .yellow)
	}
}
