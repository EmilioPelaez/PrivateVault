//
//  Publisher.swift
//  Currency
//
//  Created by Emilio Peláez on 13/10/2020.
//  Copyright © 2020 Emilio Peláez. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
	
	func peek(watcher: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
		handleOutput(handler: watcher)
	}
	
	func tryPeek(watcher: @escaping (Output) -> Void) -> Publishers.TryMap<Self, Output> {
		tryMap {
			watcher($0)
			return $0
		}
	}
	
	func peekError(watcher: @escaping (Failure) -> Void) -> Publishers.MapError<Self, Failure> {
		mapError {
			watcher($0)
			return $0
		}
	}
	
	var didSet: Publishers.Delay<Self, RunLoop> {
		delay(for: 0, scheduler: .main)
	}
	
	func handleSubscription(handler: @escaping (Subscription) -> Void) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveSubscription: handler)
	}
	
	func handleOutput(handler: @escaping (Output) -> Void) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveOutput: handler)
	}
	
	func handleCompletion(handler: @escaping (Subscribers.Completion<Failure>) -> Void) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveCompletion: handler)
	}
	
	func handleCancel(handler: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveCancel: handler)
	}
	
	func handleRequest(handler: @escaping (Subscribers.Demand) -> Void) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveRequest: handler)
	}
	
	func result(handler: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
		sink {
			guard case let .failure(error) = $0 else { return }
			handler(.failure(error))
		} receiveValue: {
			handler(.success($0))
		}
	}
	
}
