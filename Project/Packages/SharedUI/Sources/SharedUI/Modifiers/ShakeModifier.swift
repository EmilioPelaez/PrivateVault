//
//  ShakeModifier.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

public struct ShakeModifier: GeometryEffect {
	var distance: CGFloat = 10
	var shakeCount = 3
	public var animatableData: CGFloat
	
	public init(distance: CGFloat = 10, shakeCount: Int = 3, animatableData: CGFloat) {
		self.distance = distance
		self.shakeCount = shakeCount
		self.animatableData = animatableData
	}
	
	var translation: CGFloat {
		distance * sin(animatableData * .pi * CGFloat(shakeCount))
	}

	public func effectValue(size _: CGSize) -> ProjectionTransform {
		ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
	}
}

public extension View {
	func shake(_ shake: Bool, distance: CGFloat = 10, count: Int = 3) -> some View {
		modifier(ShakeModifier(distance: distance, shakeCount: count, animatableData: shake ? 1 : 0))
	}
}
