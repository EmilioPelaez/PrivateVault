//
//  View+Preview.swift
//  Views
//
//  Created by Emilio Peláez on 13/11/21.
//

import SwiftUI

public extension View {
	
	func preparePreview() -> some View {
		padding()
			.background(Color.secondarySystemBackground)
			.previewLayout(.sizeThatFits)
	}
	
	@ViewBuilder
	func previewColorSchemes() -> some View {
		colorScheme(.light)
		colorScheme(.dark)
	}
	
	@ViewBuilder
	func previewFontSizes(showAccessibility: Bool = false) -> some View {
		environment(\.dynamicTypeSize, .xSmall)
		environment(\.dynamicTypeSize, .medium)
		environment(\.dynamicTypeSize, .xxxLarge)
		if showAccessibility {
			environment(\.dynamicTypeSize, .accessibility5)
		}
	}
	
}
