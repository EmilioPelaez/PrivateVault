//
//  LockRouter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 31/03/22.
//

import HierarchyResponder
import LockScreen
import SwiftUI

struct LockRouter: ViewModifier {
	@Environment(\.passcodeSet) var passcodeSet
	@Environment(\.appLocked) var appLocked
	
	func body(content: Content) -> some View {
		if !passcodeSet {
			PasscodeSetScreen()
				.transition(.move(edge: .bottom))
				.zIndex(1)
		} else if appLocked {
			LockScreen()
				.transition(.move(edge: .bottom))
				.zIndex(1)
		} else {
			content
				.transition(.scale(scale: 0.85))
		}
	}
}

extension View {
	///	Shows and hides the lock screen, as well as the passcode set screen
	func lockRouter() -> some View {
		modifier(LockRouter())
	}
}
