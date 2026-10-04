//
//  Binding+Map.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

public extension Binding {
	func map<T>(
		to: @escaping (Value) -> T,
		from: @escaping (T) -> Value
	) -> Binding<T> {
		.init(get: {
			to(wrappedValue)
		}, set: { value in
			wrappedValue = from(value)
		})
	}
}

public extension Binding where Value == Int {
	func toString() -> Binding<String> {
		map(to: String.init) {
			Int($0.filter(\.isNumber)) ?? 0
		}
	}
}
