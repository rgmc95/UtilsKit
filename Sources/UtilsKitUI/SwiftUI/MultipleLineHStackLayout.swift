//
//  MultipleLineHStackLayout.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import SwiftUI

@available(iOS 16.0, *)
private struct MultipleLineHStackLayout: Layout {
	
	let horizontaleSpacing: Double
	let verticalSpacing: Double
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		guard let width = proposal.width else { return .zero }
		let height = self.getHeight(proposal: proposal, subviews: subviews)
		return CGSize(width: width, height: height)
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		var pt = CGPoint(x: bounds.minX, y: bounds.minY)
		var currentLineHeight: CGFloat = 0
		
		for subview in subviews.sorted(by: { $0.priority > $1.priority }) {
			let size = subview.sizeThatFits(proposal)
			
			if (pt.x + size.width) > bounds.maxX {
				pt.x = bounds.minX
				pt.y += currentLineHeight + verticalSpacing
				currentLineHeight = 0
			}
			
			subview.place(at: pt, anchor: .topLeading, proposal: proposal)
			pt.x += size.width + horizontaleSpacing
			currentLineHeight = max(currentLineHeight, size.height)
		}
	}
	
	private func getHeight(proposal: ProposedViewSize, subviews: Subviews) -> CGFloat {
		guard let width = proposal.width else { return 0 }
		
		var positionX: CGFloat = 0
		var currentLineHeight: CGFloat = 0
		
		var height: CGFloat = 0
		
		for subview in subviews.sorted(by: { $0.priority > $1.priority }) {
			let size = subview.sizeThatFits(proposal)
			
			if (positionX + size.width) > width {
				height += currentLineHeight
				height += verticalSpacing
				currentLineHeight = 0
				positionX = 0
			}
			
			positionX += size.width + horizontaleSpacing
			currentLineHeight = max(currentLineHeight, size.height)
		}
		
		height += currentLineHeight
		
		return height
	}
	
	
	private func calculateNumberOrRow(for subviews: Subviews, with width: Double) -> Int {
		var nbRows = 0
		var x: Double = 0
		
		for subview in subviews {
			let addedX = subview.sizeThatFits(.unspecified).width + horizontaleSpacing
			
			let isXWillGoBeyondBounds = x + addedX > width
			if isXWillGoBeyondBounds {
				x = 0
				nbRows += 1
			}
			
			x += addedX
		}
		
		if x > 0 {
			nbRows += 1
		}
		
		return nbRows
	}
}

@available(iOS 16.0, *)
/// A view that arranges its content in a multiple-line horizontal stack, where items wrap onto new lines when there is not enough horizontal space.
public struct MultipleLineHStack<Content: View>: View {
	
	let horizontaleSpacing: Double
	let verticalSpacing: Double
	let content: () -> Content
	
	public var body: some View {
		MultipleLineHStackLayout(horizontaleSpacing: horizontaleSpacing,
								 verticalSpacing: verticalSpacing) {
			content()
		}
	}
	
	/// Initializes a `MultipleLineHStack` with optional horizontal and vertical spacing and a closure for the content.
	///
	/// - Parameters:
	///   - horizontaleSpacing: The horizontal space between subviews. Default is `8`.
	///   - verticalSpacing: The vertical space between rows of subviews. Default is `8`.
	///   - content: A closure that defines the content of the stack.
	public init(horizontaleSpacing: Double = 8,
				verticalSpacing: Double = 8,
				content: @escaping () -> Content) {
		self.horizontaleSpacing = horizontaleSpacing
		self.verticalSpacing = verticalSpacing
		self.content = content
	}
}
