//
//  PasscodeSetResponder.swift
//  LockScreen
//
//  Created by Emilio Peláez on 03/04/22.
//

import HierarchyResponder
import SwiftUI

struct PasscodeSetResponder: ViewModifier {
	@Environment(\.triggerEvent) var triggerEvent
	
	@State var passcodeLength = 6
	@State var newPasscode = ""
	@State var input = ""
	@State var confirming = false
	
	func body(content: Content) -> some View {
		content
			.handleEvent(KeyDownEvent.self, handler: handleKeyDown)
			.handleEvent(KeypadDeleteEvent.self, handler: handleBackspace)
			.handleEvent(PasscodeLengthSetEvent.self) {
				passcodeLength = $0.length
				input = ""
			}
			.environment(\.passcodeEntered, input)
			.environment(\.passcodeLength, passcodeLength)
			.environment(\.passcodeConfirming, confirming)
			.environment(\.biometricsState, .none)
	}
	
	func handleKeyDown(_ event: KeyDownEvent) {
		input = String((input + event.value).prefix(passcodeLength))
		guard input.count == passcodeLength else { return }
		guard confirming else {
			newPasscode = input
			input = ""
			confirming = true
			return
		}
		if input == newPasscode {
			triggerEvent(PasscodeSetEvent(passcode: newPasscode))
		} else {
			withAnimation {
				confirming = false
				newPasscode = ""
				input = ""
			}
		}
	}
	
	func handleBackspace() {
		input = String(input.dropLast())
	}
}

extension View {
	func passcodeSetResponder() -> some View {
		modifier(PasscodeSetResponder())
	}
}
