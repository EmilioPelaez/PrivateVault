//
//  LockRouter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 31/03/22.
//

import SwiftUI
import LockScreen

struct LockRouter: View {
	@State var locked = true
	
	var body: some View {
		if locked {
			LockScreen()
				.transition(.move(edge: .bottom))
				.handleEvent(UnlockEvent.self, handler: unlock)
				.zIndex(1)
		} else {
			Button(action: lock) {
				Label("Lock", systemImage: "lock.fill")
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			.transition(.scale(scale: 0.85))
		}
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
