//
//  NotificationCenter+Observers.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 17/01/2022.
//  Copyright © 2022 RGMC. All rights reserved.
//

import Foundation

extension NotificationCenter {
	
	/**
	 Adds multi entries to the notification center to receive notifications that passed to the provided block.
	 */
	public func addObservers(_ notifications: Notification.Name...,
							 queue: OperationQueue = .main,
							 completion: @escaping @Sendable (Notification) -> Void) {
		self.addObservers(notifications, queue: queue, completion: completion)
	}
	
	/**
	 Adds multi entries to the notification center to receive notifications that passed to the provided block.
	 */
	public func addObservers(_ notifications: [Notification.Name],
							 queue: OperationQueue = .main,
							 completion: @escaping @Sendable (Notification) -> Void) {
		notifications
			.forEach {
				_ = NotificationCenter
					.default
					.addObserver(forName: $0,
								 object: nil,
								 queue: queue) { notification in
						completion(notification)
					}
			}
	}
}
