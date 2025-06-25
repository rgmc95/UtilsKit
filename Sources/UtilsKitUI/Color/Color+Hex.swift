
//
//  Color+Hex.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import SwiftUI
import UIKit

@available(iOS 15.0, *)
extension Color {
	
	
	/**
	 Custom initializer to create a Color from a hexadecimal code.
	 
	 - parameter hex: Hexadecimal code (#....).
	 */
	public init(hex: String) {
		self.init(uiColor: UIColor(withHexString: hex) ?? .clear)
	}
}
