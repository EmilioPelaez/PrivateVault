//
//  View+OnChangeEqual.swift
//  UISupport
//
//  Created by Emilio Peláez on 11/12/21.
//

import SwiftUI

public extension View {
	func onChange<T: Equatable>(of value: T, equals baseline: T, perform: @escaping () -> Void) -> some View {
		onChange(of: value) { newValue in
			guard newValue == baseline else { return }
			perform()
		}
	}
}
