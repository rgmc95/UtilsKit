//
//  Async.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 30/03/2023.
//

import Foundation

/// Invokes the passed in closure with a checked continuation for the current task in queue
public func withCheckedContinuationAsync<T: Any>(in queue: DispatchQueue,
												 completion: @escaping (CheckedContinuation<T, Never>) -> Void) async -> T {
	await withCheckedContinuation { (continuation: CheckedContinuation<T, Never>) in
		queue.async {
			completion(continuation)
		}
	}
}

/// Invokes the passed in closure with a checked continuation for the current task in queue
public func withCheckedThrowingContinuationAsync<T: Any>(in queue: DispatchQueue,
														 completion: @escaping (CheckedContinuation<T, Error>) -> Void) async throws -> T {
	try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
		queue.async {
			completion(continuation)
		}
	}
}

/// Invokes the passed in closure with a checked continuation for the current task in queue
public func withCheckedThrowingContinuationAsync<T: Any>(in queue: DispatchQueue,
														 completion: @escaping () throws -> T) async throws -> T {
	try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
		queue.async {
			do {
				let value = try completion()
				continuation.resume(returning: value)
			} catch {
				continuation.resume(throwing: error)
			}
		}
	}
}

/// Invokes the passed in closure with a unsafe continuation for the current task in queue
public func withUnsafeThrowingContinuationAsync<T: Any>(in queue: DispatchQueue,
														completion: @escaping (UnsafeContinuation<T, Error>) -> Void) async throws -> T {
	try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<T, Error>) in
		queue.async {
			completion(continuation)
		}
	}
}
