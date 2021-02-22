//
//  Binding+Optional.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

extension Binding {
	func `default`<Wrapped>(_ default: Wrapped) -> Binding<Wrapped> where Wrapped? == Value {
		Binding<Wrapped>(get: { wrappedValue ?? `default` },
										 set: { wrappedValue = $0 })
	}
}
