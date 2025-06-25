//
//  CLLocationCoordinate2D+Error.swift
//
//
//  Created by Michael Coqueret on 22/11/2023.
//

public struct UnknownAddress: Error {
	public init() { }
}

public struct UnknownCoordinate: Error {
	public init() { }
}

public struct UnknownRoute: Error {
	public init() { }
}
