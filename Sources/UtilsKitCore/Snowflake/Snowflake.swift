//
//  Snowflake.swift
//  Trivel
//
//  Created by Michael Coqueret on 25/02/2025.
//  Copyright © 2025 Trivel. All rights reserved.
//

import UIKit

public class Snowflake {
	
	private static let shared = Snowflake()
	
	public static func generate() -> Int {
		Self.shared.generate()
	}
	
	public static func set(epoch: Int) {
		Self.shared.epoch = epoch
	}
	
	private var lastTimestamp: Int = 0
	private let machineId: Int
	
	private var sequence: Int = 0
	private var epoch: Int = 928_329_300
	
	private init() {
		self.machineId = (Int(UIDevice.current.identifierForVendor?.uuidString ?? "") ?? 0) & 0b1111111111
	}
	
	private func generate() -> Int {
		let timestamp = currentTimestamp()
		
		if timestamp == lastTimestamp {
			sequence = (sequence + 1) & 0b111111111111
			if sequence == 0 {
				while currentTimestamp() <= lastTimestamp {}
			}
		} else {
			sequence = 0
		}
		
		lastTimestamp = timestamp
		
		return ((timestamp - epoch) << 22) | (machineId << 12) | sequence
	}
	
	private func currentTimestamp() -> Int {
		Int(Date().timeIntervalSince1970 * 1000)
	}
}
