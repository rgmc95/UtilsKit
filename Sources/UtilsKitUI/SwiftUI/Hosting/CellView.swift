//
//  CellView.swift
//  Total
//
//  Created by Steven on 28/06/2021.
//  Copyright © 2021 Exomind. All rights reserved.
//

import SwiftUI

public protocol CellView: View {
	
    static var identifier: String { get }
}

extension CellView {
	
	/// Cell identifier
	public static var identifier: String {
		"\(Self.self)"
	}
}
