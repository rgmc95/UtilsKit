//
//  ObservableObject+Listen.swift
//
//
//  Created by Michael Coqueret on 16/02/2024.
//

import Foundation
import Combine

public extension ObservableObject {
	
	/**
	 Listens for changes in the object and executes a completion closure when changes occur.
	 - Parameters:
	 - subscribers: A set of `AnyCancellable` objects that will be retained as long as the observation is active.
	 - scheduler: The dispatch queue on which to receive and handle the changes. Defaults to the main queue.
	 - completion: A closure to be executed when changes are detected in the object.
	 **/
	func listen(subscribers: inout Set<AnyCancellable>,
				scheduler: DispatchQueue = .main,
				completion: @escaping () -> Void) {
		self.objectWillChange
			.receive(on: scheduler)
			.sink { _ in
				completion()
			}
			.store(in: &subscribers)
	}
}
