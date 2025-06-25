//
//  NullEncodable.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 25/06/2025.
//

/**
 A property wrapper that enables encoding of optional values as `null` in JSON.
 
 `NullEncodable` is a property wrapper that allows optional values to be encoded as `null` in JSON when the value is `nil`. This is particularly useful when you want to ensure that `nil` values are explicitly represented in the encoded JSON output.
 
 - Note: The generic type `T` must conform to the `Encodable` protocol.
 */
@propertyWrapper
public struct NullEncodable<T>: Encodable where T: Encodable {
	
	/// The wrapped value of the property.
	public var wrappedValue: T?
	
	/**
	 Initializes a new instance of `NullEncodable`.
	 
	 - Parameter wrappedValue: The optional value to be wrapped.
	 */
	public init(wrappedValue: T?) {
		self.wrappedValue = wrappedValue
	}
	
	/**
	 Encodes the wrapped value into the given encoder.
	 
	 This method attempts to encode the wrapped value if it is non-nil. If the wrapped value is `nil`, it encodes `null` into the encoder's single value container.
	 
	 - Parameter encoder: The encoder to write data to.
	 - Throws: An error if encoding fails.
	 */
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch wrappedValue {
		case .some(let value): try container.encode(value)
		case .none: try container.encodeNil()
		}
	}
}
