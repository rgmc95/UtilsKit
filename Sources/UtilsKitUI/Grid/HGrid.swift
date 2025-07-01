//
//  HGrid.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 25/06/2025.
//

import SwiftUI

@available(iOS 16.0, *)
private struct HGridLayout: Layout {
	
	let reversed: Bool
	let numberOfColumns: Int
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
			
			let itemWidth = self.getWidth(for: subview, in: subviews, proposal: proposal)
			
			if (pt.x + itemWidth) > bounds.maxX {
				pt.x = bounds.minX
				pt.y += currentLineHeight + verticalSpacing
				currentLineHeight = 0
			}
			
			subview.place(at: pt, anchor: .topLeading, proposal: .init(width: itemWidth,
																	   height: proposal.height))
			pt.x += itemWidth + horizontaleSpacing
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
			let itemWidth = self.getWidth(for: subview, in: subviews, proposal: proposal)
			
			if (positionX + itemWidth) > width {
				height += currentLineHeight + verticalSpacing
				currentLineHeight = 0
				positionX = 0
			}
			
			positionX += itemWidth + horizontaleSpacing
			currentLineHeight = max(currentLineHeight, size.height)
		}
		
		height += currentLineHeight
		
		return height
	}
	
	func getWidth(for subview: LayoutSubview,
				  in subviews: Subviews,
				  proposal: ProposedViewSize) -> CGFloat {
		guard let width = proposal.width else { return 0 }
		
		if subviews.count.isMultiple(of: self.numberOfColumns) {
			return self.getItemWidth(width: width, numberOfColumns: self.numberOfColumns)
		}
		
		let modulo = subviews.count % self.numberOfColumns
		let lasts: Subviews
		
		if reversed {
			lasts = subviews.prefix(modulo)
		} else {
			lasts = subviews.suffix(modulo)
		}
		
		if lasts.contains(subview) {
			return self.getItemWidth(width: width, numberOfColumns: modulo)
		} else {
			return self.getItemWidth(width: width, numberOfColumns: self.numberOfColumns)
		}
	}
	
	func getItemWidth(width: CGFloat, numberOfColumns: Int) -> CGFloat {
		(width - self.horizontaleSpacing * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
	}
}

/// A view that arranges its content in a multiple-line horizontal stack, where items wrap onto new lines when there is not enough horizontal space.
@available(iOS 16.0, *)
public struct HGrid<Content: View>: View {
	
	let numberOfColumns: Int
	let reversed: Bool
	let horizontaleSpacing: Double
	let verticalSpacing: Double
	@ViewBuilder var content: () -> Content
	
	public var body: some View {
		HGridLayout(reversed: self.reversed,
					numberOfColumns: numberOfColumns,
					horizontaleSpacing: horizontaleSpacing,
					verticalSpacing: verticalSpacing) {
			content()
		}
	}
	
	/// Initializes a `HGrid` with optional horizontal and vertical spacing and a closure for the content.
	///
	/// - Parameters:
	///   - numberOfColumns: The number of columns in the grid.
	///   - reversed: Determines if the grid should be reversed. Default is `false`.
	///   - horizontaleSpacing: The horizontal space between subviews. Default is `8`.
	///   - verticalSpacing: The vertical space between rows of subviews. Default is `8`.
	///   - content: A closure that defines the content of the grid.
	public init(numberOfColumns: Int,
				reversed: Bool = false,
				horizontaleSpacing: Double = 8,
				verticalSpacing: Double = 8,
				@ViewBuilder content: @escaping () -> Content) {
		self.numberOfColumns = numberOfColumns
		self.reversed = reversed
		self.horizontaleSpacing = horizontaleSpacing
		self.verticalSpacing = verticalSpacing
		self.content = content
	}
}
