//
//  LockRouter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 31/03/22.
//

import HierarchyResponder
import SwiftUI
import LockScreen

struct LockRouter: View {
	@Environment(\.passcodeSet) var passcodeSet
	@Environment(\.appLocked) var appLocked
	
	var body: some View {
		if !passcodeSet {
			PasscodeSetScreen()
				.transition(.move(edge: .bottom))
				.zIndex(1)
		} else if appLocked {
			LockScreen()
				.transition(.move(edge: .bottom))
				.zIndex(1)
		} else {
			EventButton(LockEvent()) {
				Label("Lock", systemImage: "lock.fill")
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			.transition(.scale(scale: 0.85))
		}
	}
}
