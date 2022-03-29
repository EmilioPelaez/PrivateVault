//
//  OverrideColorScheme.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 24/4/21.
//

import SwiftUI

struct OverrideColorScheme: ViewModifier {
	let override: Bool
	let colorScheme: ColorScheme
	
	func body(content: Content) -> some View {
		if override {
			content.colorScheme(colorScheme)
		} else {
			content
		}
	}
}

extension View {
	func overrideColorScheme(override: Bool, colorScheme: ColorScheme) -> some View {
		modifier(OverrideColorScheme(override: override, colorScheme: colorScheme))
	}
}
