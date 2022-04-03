//
//  AppLockResponder.swift
//  LockScreen
//
//  Created by Emilio Peláez on 03/04/22.
//

import HierarchyResponder
import SharedUI
import SwiftUI

struct AppLockResponder: ViewModifier {
	@StateObject var passcodeManager = PasscodeManager()
	@State var locked = true
	
	func body(content: Content) -> some View {
		content
			.handleEvent(LockEvent.self, handler: lock)
			.handleEvent(UnlockEvent.self, handler: unlock)
			.handleEvent(PasscodeSetEvent.self) { event in
				passcodeManager.setPasscode(event.passcode)
				locked = false
			}
			.animateEnvironment(\.passcodeSet)
			.environment(\.appLocked, locked)
			.environment(\.passcodeSet, passcodeManager.passcodeSet)
			.environmentObject(passcodeManager)
	}
	
	func lock() {
		locked = true
	}
	
	func unlock() {
		withAnimation {
			locked = false
		}
	}
}

public extension View {
	func appLockResponder() -> some View {
		modifier(AppLockResponder())
	}
}
