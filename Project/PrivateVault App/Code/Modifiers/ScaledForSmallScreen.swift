//
//  ScaledForSmallScreen.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 14/3/21.
//

import SwiftUI

//	If the device's screen height is equal or smaller than the cuttoff, apply the scale
struct ScaledForSmallScreen: ViewModifier {
	let cutoff: CGFloat
	let scale: CGFloat
	
	func body(content: Content) -> some View {
		if UIScreen.main.bounds.height <= cutoff {
			content.scaleEffect(scale)
		} else {
			content
		}
	}
}

extension View {
	func scaledForSmallScreen(cutoff: CGFloat, scale: CGFloat) -> some View {
		modifier(ScaledForSmallScreen(cutoff: cutoff, scale: scale))
	}
}
