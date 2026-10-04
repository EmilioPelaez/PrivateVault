//
//  LockedOutModifier.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import SwiftUI

public struct LockedOutModifier: ViewModifier {
	let isBlurred: Bool
	
	public init(isBlurred: Bool) {
		self.isBlurred = isBlurred
	}
	
	private var blurRadius: CGFloat { isBlurred ? 8 : 0 }
	private var opacity: Double { isBlurred ? 1 : 0 }
	
	public func body(content: Content) -> some View {
		if isBlurred {
			ZStack {
				content
					.blur(radius: blurRadius, opaque: false)
					.disabled(true)
				Image(systemName: "lock")
					.font(.largeTitle)
					.padding()
					.foregroundColor(.white)
					.background(Color.red)
					.clipShape(Circle())
			}
		} else {
			content
		}
	}
}

public extension View {
	func lockedOut(_ locked: Bool) -> some View {
		modifier(LockedOutModifier(isBlurred: locked))
	}
}
