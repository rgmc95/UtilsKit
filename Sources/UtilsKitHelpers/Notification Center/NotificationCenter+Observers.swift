//
//  NotificationCenter+Observers.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 17/01/2022.
//  Copyright © 2022 RGMC. All rights reserved.
//

import Foundation

//swiftlint:disable discarded_notification_center_observer

extension NotificationCenter {
	
	/**
	 Adds multi entries to the notification center to receive notifications that passed to the provided block.
	 */
	public func addObservers(_ notifications: Notification.Name...,
					  queue: OperationQueue = .main,
					  completion: @escaping ((Notification) -> Void)) {
		self.addObservers(notifications, queue: queue, completion: completion)
	}
	
	/**
	 Adds multi entries to the notification center to receive notifications that passed to the provided block.
	 */
	public func addObservers(_ notifications: [Notification.Name],
							 queue: OperationQueue = .main,
							 completion: @escaping ((Notification) -> Void)) {
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
	
	/**
	 Adds multi entries to the notification center to receive notifications that passed to the provided async block.
	 */
	public func addObservers(_ notifications: Notification.Name...,
							 completion: @escaping (() async -> Void)) {
		self.addObservers(notifications) { _ in
			Task {
				await completion()
			}
		}
	}
}
