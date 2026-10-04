//
//  Publisher.swift
//  Currency
//
//  Created by Emilio Peláez on 13/10/2020.
//  Copyright © 2020 Emilio Peláez. All rights reserved.
//

import Combine
import Foundation

public extension Publisher {
	func result(handler: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
		sink {
			guard case let .failure(error) = $0 else { return }
			handler(.failure(error))
		} receiveValue: {
			handler(.success($0))
		}
	}
}
