//
//  OverrideColorScheme.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 24/4/21.
//

import SwiftUI

public struct OverrideColorScheme: ViewModifier {
	let override: Bool
	let colorScheme: ColorScheme
	
	public init(override: Bool, colorScheme: ColorScheme) {
		self.override = override
		self.colorScheme = colorScheme
	}
	
	public func body(content: Content) -> some View {
		if override {
			content.colorScheme(colorScheme)
		} else {
			content
		}
	}
}

public extension View {
	func overrideColorScheme(override: Bool, colorScheme: ColorScheme) -> some View {
		modifier(OverrideColorScheme(override: override, colorScheme: colorScheme))
	}
}
