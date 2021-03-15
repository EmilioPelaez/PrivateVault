//
//  ShakeModifier.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct ShakeModifier: GeometryEffect {
	var distance: CGFloat = 10
	var shakeCount = 3
	var animatableData: CGFloat

	var translation: CGFloat {
		distance * sin(animatableData * .pi * CGFloat(shakeCount))
	}

	func effectValue(size: CGSize) -> ProjectionTransform {
		ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
	}
}

extension View {
	func shake(_ shake: Bool, distance: CGFloat = 10, count: Int = 3) -> some View {
		modifier(ShakeModifier(distance: distance, shakeCount: count, animatableData: shake ? 1 : 0))
	}
}
