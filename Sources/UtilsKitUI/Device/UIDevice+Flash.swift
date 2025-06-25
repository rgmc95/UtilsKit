//
//  UIDevice+Flash.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import OSLog
import UtilsKitCore

extension Logger {
	static let device = Logger(subsystem: "UtilsKit", category: "Device")
}

@available(iOSApplicationExtension, introduced: 1.0, unavailable)
extension UIDevice {
	
	/**
	 Indicate if the torch is ON.
	 
	 - returns: a `boolean` value indicating if the torch is ON
	 */
	public var isFlashlightOn: Bool {
		guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return false }
		return device.torchMode == .on
	}
	
	/**
	 Toggle the state of the torch.
	 
	 - parameter on: `true` lights on the torch.
	 */
	public func toggleTorch(active: Bool) {
		guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
		
		if device.hasTorch {
			do {
				try device.lockForConfiguration()
				device.torchMode =  active ? .on : .off
				device.unlockForConfiguration()
			} catch {
				Logger.device.fault("Torch  - \(error.localizedDescription)")
			}
		} else {
			Logger.device.fault("Torch is not available")
		}
	}
}
