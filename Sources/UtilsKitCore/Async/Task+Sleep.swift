//
//  Task+Sleep.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/01/2025.
//

import Foundation

extension Task where Success == Never, Failure == Never {
	
	/// Suspends the current task for at least the given duration
	/// in second.
	///
	/// If the task is canceled before the time ends,
	/// this function throws `CancellationError`.
	///
	/// This function doesn't block the underlying thread.
	public static func sleep(seconds: Double) async {
		try? await Self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
	}
}
