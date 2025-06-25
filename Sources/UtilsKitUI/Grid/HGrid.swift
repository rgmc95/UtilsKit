//
//  HGrid.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 25/06/2025.
//

import SwiftUI

/**
 A view that arranges its child views in a horizontal grid layout.
 
 `HGrid` is a custom SwiftUI view that organizes a collection of data into a grid with a specified number of columns. Each item in the collection is rendered using a provided content builder.
 
 - Parameters:
 - Data: A type representing a collection of identifiable data.
 - ID: A type representing the stable identity of the data.
 - Content: A type representing the view that this grid will produce for each data element.
 
 - Properties:
 - items: An array of tuples, each containing a unique identifier and an array of data elements to be displayed in a row.
 - id: A key path to the data element's identifier.
 - content: A view builder that defines the content for each data element.
 - verticalSpacing: The spacing between rows in the grid.
 - horizontalSpacing: The spacing between items in a row.
 */
public struct HGrid<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View {
	
	let items: [(UUID, [Data.Element])]
	let id: KeyPath<Data.Element, ID>
	@ViewBuilder let content: (Data.Element) -> Content
	
	let verticalSpacing: CGFloat
	let horizontalSpacing: CGFloat
	
	public var body: some View {
		VStack(spacing: verticalSpacing) {
			ForEach(items, id: \.0) { values in
				HStack(spacing: horizontalSpacing) {
					ForEach(values.1, id: id) { value in
						content(value)
					}
				}
			}
		}
	}
	
	/**
	 Initializes a new `HGrid` with the given data, identifier key path, number of columns, and spacing values.
	 
	 - Parameters:
	 - data: The collection of data to display in the grid.
	 - id: A key path to the data element's identifier.
	 - columns: The number of columns in the grid.
	 - verticalSpacing: The spacing between rows in the grid. The default value is 8.
	 - horizontalSpacing: The spacing between items in a row. The default value is 8.
	 - content: A view builder that defines the content for each data element.
	 */
	public init(_ data: Data,
				id: KeyPath<Data.Element, ID>,
				columns: Int,
				verticalSpacing: CGFloat = 8,
				horizontalSpacing: CGFloat = 8,
				@ViewBuilder content: @escaping (Data.Element) -> Content) {
		self.id = id
		self.verticalSpacing = verticalSpacing
		self.horizontalSpacing = horizontalSpacing
		self.content = content
		
		var pairs: [(UUID, [Data.Element])] = []
		let strideRange = stride(from: 0, to: data.count, by: columns)
		let _items = Array(data)
		
		for index in strideRange {
			let endIndex = min(index + columns, data.count)
			let pair = Array(_items[index..<endIndex])
			pairs.append((.init(), pair))
		}
		
		self.items = pairs
	}
}
