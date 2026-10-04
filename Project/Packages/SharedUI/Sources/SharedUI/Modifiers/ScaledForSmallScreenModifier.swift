//
//  ScaledForSmallScreenModifier.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 14/3/21.
//

import SwiftUI

//	If the device's screen height is equal or smaller than the cuttoff, apply the scale
public struct ScaledForSmallScreenModifier: ViewModifier {
	let cutoff: CGFloat
	let scale: CGFloat
	
	public init(cutoff: CGFloat, scale: CGFloat) {
		self.cutoff = cutoff
		self.scale = scale
	}
	
	public func body(content: Content) -> some View {
		if UIScreen.main.bounds.height <= cutoff {
			content.scaleEffect(scale)
		} else {
			content
		}
	}
}

public extension View {
	func scaledForSmallScreen(cutoff: CGFloat, scale: CGFloat) -> some View {
		modifier(ScaledForSmallScreenModifier(cutoff: cutoff, scale: scale))
	}
}
