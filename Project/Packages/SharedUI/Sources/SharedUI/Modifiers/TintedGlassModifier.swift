//
//  TintedGlassModifier.swift
//  SharedUI
//
//  Created by Emilio Peláez on 4/10/26.
//

import SwiftUI

//	Tinted glass where available, a shape filled with the color everywhere else
public struct TintedGlassModifier<S: Shape>: ViewModifier {
	let color: Color
	let shape: S
	let interactive: Bool
	let fallbackShadow: Bool
	
	public init(color: Color, shape: S, interactive: Bool, fallbackShadow: Bool) {
		self.color = color
		self.shape = shape
		self.interactive = interactive
		self.fallbackShadow = fallbackShadow
	}
	
	public func body(content: Content) -> some View {
		if #available(iOS 26.0, *) {
			content
				.glassEffect(.regular.interactive(interactive).tint(color), in: shape)
		} else {
			content
				.background(
					shape
						.fill(color)
						.shadow(color: Color(white: 0, opacity: fallbackShadow ? 0.2 : 0), radius: 4, x: 0, y: 2)
				)
		}
	}
}

public extension View {
	func tintedGlass<S: Shape>(_ color: Color, in shape: S, interactive: Bool = true, fallbackShadow: Bool = false) -> some View {
		modifier(TintedGlassModifier(color: color, shape: shape, interactive: interactive, fallbackShadow: fallbackShadow))
	}
	
	func tintedGlass(_ color: Color, interactive: Bool = true, fallbackShadow: Bool = false) -> some View {
		tintedGlass(color, in: Circle(), interactive: interactive, fallbackShadow: fallbackShadow)
	}
}
