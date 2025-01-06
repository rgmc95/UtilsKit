//
//  Binding+Optional.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import SwiftUI

extension Binding {
	
	/// Provides a default value for a `Binding` of an optional type.
	///
	/// This custom implementation of the `??` operator allows you to create a `Binding` that returns a non-optional value by providing a default value when the original `Binding` contains `nil`.
	///
	/// - Parameters:
	///   - lhs: A `Binding` to an optional value (`Binding<Value?>`).
	///   - rhs: A default value of type `Value` to use when the `Binding`'s wrapped value is `nil`.
	/// - Returns: A new `Binding` of type `Binding<Value>` that returns the wrapped value if it exists, or the default value if the wrapped value is `nil`.
	///
	/// ### Example Usage
	/// ```swift
	/// struct ContentView: View {
	///     @State private var optionalText: String? = nil
	///
	///     var body: some View {
	///         TextField("Enter text", text: $optionalText ?? "Default Value")
	///     }
	/// }
	/// ```
	///
	/// In this example, if `optionalText` is `nil`, the `TextField` will display "Default Value" as its initial text. If a new value is entered, it will update `optionalText` accordingly.
	///
	/// ### How It Works
	/// - The getter returns the wrapped value of the original `Binding` if it's not `nil`; otherwise, it returns the provided default value.
	/// - The setter updates the original `Binding` with the new value.
	public static func ?? (lhs: Binding<Value?>, rhs: Value) -> Binding<Value> {
		Binding {
			lhs.wrappedValue ?? rhs
		} set: {
			lhs.wrappedValue = $0
		}
	}
}
