//
//  LockScreenResponder.swift
//  LockScreen
//
//  Created by Emilio Peláez on 30/03/22.
//

import HierarchyResponder
import SwiftUI

struct LockScreenResponder: ViewModifier {
	@Environment(\.triggerEvent) var triggerEvent
	
	let passcode: String = "1234"
	@Binding var input: String
	@State var passcodeState = PasscodeState.undefined
	@State var disabled = false
	
	func body(content: Content) -> some View {
		content
			.allowsHitTesting(!disabled)
			.handleEvent(KeyDownEvent.self, handler: handleKeyDown)
			.handleEvent(KeypadDeleteEvent.self, handler: handleBackspace)
			.environment(\.passcodeState, passcodeState)
	}
	
	func handleKeyDown(_ event: KeyDownEvent) {
		input = String((input + event.value).prefix(passcode.count))
		updateState()
	}
	
	func handleBackspace() {
		input = String(input.dropLast())
		updateState()
	}
	
	func updateState() {
		withAnimation {
			if input == passcode {
				passcodeState = .correct
				disabled = true
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					triggerEvent(UnlockEvent())
				}
			} else if input.count == passcode.count {
				passcodeState = .incorrect
				disabled = true
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					input = ""
					disabled = false
					updateState()
				}
			} else {
				passcodeState = .undefined
			}
		}
	}
}

extension View {
	func lockScreenResponder(input: Binding<String>) -> some View {
		modifier(LockScreenResponder(input: input))
	}
}
