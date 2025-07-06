//
//  Snowflake.swift
//  Trivel
//
//  Created by Michael Coqueret on 25/02/2025.
//  Copyright © 2025 Trivel. All rights reserved.
//

import Foundation

public class Snowflake: @unchecked Sendable {
	
	private static let shared = Snowflake()
	
	public static func generate() -> Int {
		Self.shared.generate()
	}
	
	public static func set(epoch: Int) {
		Self.shared.set(epoch: epoch)
	}
	
	public static func getDeviceId() -> String {
		if let value = UserDefaults(suiteName: "UtilsKit")?.string(forKey: "deviceID") {
			return value
		}
		
		let value = UUID().uuidString
		UserDefaults(suiteName: "UtilsKit")?.set(value, forKey: "deviceID")
		return value
	}
	
	private var lastTimestamp: Int = 0
	private let machineId: Int
	
	private var sequence: Int = 0
	private var epoch: Int = 928_329_300
	
	private init() {
		self.machineId = (Int(Self.getDeviceId()) ?? 0) & 0b1111111111
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
	
	private func set(epoch: Int) {
		self.epoch = epoch
	}
}
