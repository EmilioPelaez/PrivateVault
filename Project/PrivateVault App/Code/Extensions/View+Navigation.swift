//
//  View+Navigation.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import SwiftUI

extension View {
	func navigation<V: Identifiable, Destination: View>(item: Binding<V?>,
	                                                    destination: @escaping (V) -> Destination) -> some View {
		background(NavigationLink(item: item, destination: destination))
	}
}

extension View {
	func navigation<Destination: View>(isPresenting: Binding<Bool>,
	                                   destination: Destination) -> some View {
		background(NavigationLink(destination: destination, isActive: isPresenting) {})
	}
}

public extension NavigationLink where Label == EmptyView {
	init?<V: Identifiable>(item: Binding<V?>, destination: @escaping (V) -> Destination) {
		if let value = item.wrappedValue {
			let isActive: Binding<Bool> = Binding(
				get: { item.wrappedValue != nil },
				set: { value in
					// There's shouldn't be a way for SwiftUI to set `true` here.
					if !value {
						item.wrappedValue = nil
					}
				}
			)

			self.init(destination: destination(value), isActive: isActive) { EmptyView() }
		} else {
			return nil
		}
	}
}
