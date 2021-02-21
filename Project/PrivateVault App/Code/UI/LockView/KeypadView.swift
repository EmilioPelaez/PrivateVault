//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI
import LocalAuthentication

struct KeypadView: View {
	@EnvironmentObject private var settings: UserSettings
	let input: (String) -> Void
	let delete: () -> Void
	
	func authenticate() {
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "To unlock your private vault app"
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
				DispatchQueue.main.async {
					if success {
						input(settings.passcode)
					} else {
						return
					}
				}
			}
		} else {
			return
		}
	}
	
	var body: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center) {
			ForEach(1..<10) { index in
				KeyButton(title: Text("\(index)"), color: Color(.tertiarySystemFill), textColor: .primary) {
					if settings.hapticFeedback { FeedbackGenerator.impact(.rigid) }
					input("\(index)")
				}
			}
			KeyButton(title: Image(systemName: "faceid"), color: Color(.tertiarySystemFill), textColor: .primary) {
				if settings.hapticFeedback { FeedbackGenerator.impact(.rigid) }
				authenticate()
			}
			KeyButton(title: Text("0"), color: Color(.tertiarySystemFill), textColor: .primary) {
				if settings.hapticFeedback { FeedbackGenerator.impact(.rigid) }
				input("0")
			}
			.aspectRatio(1, contentMode: .fill)
			.clipShape(Circle())
			KeyButton(title: Image(systemName: "delete.left"), color: .red, textColor: .white) {
				if settings.hapticFeedback { FeedbackGenerator.impact(.rigid) }
				delete()
			}
		}
	}
}



struct KeyButton<Body: View>: View {
	let title: Body
	let color: Color
	let textColor: Color
	let action: () -> Void
	var body: some View {
		Button(action: action, label: {
			ZStack {
				color
				title
					.font(.largeTitle)
					.foregroundColor(textColor)
			}
		})
		.aspectRatio(1, contentMode: .fill)
		.clipShape(Circle())
	}
}


struct KeypadView_Previews: PreviewProvider {
	@State static var code = ""
	
	static var previews: some View {
		KeypadView(input: { _ in }, delete: { })
			.environmentObject(UserSettings())
	}
}
