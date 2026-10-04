//
//  BiometricAuthenticationButton.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import LocalAuthentication
import Middleware
import SharedUI
import SwiftUI

public struct BiometricAuthenticationButton: View {
	@EnvironmentObject private var settings: UserSettings
	let biometricsContext = LAContext()
	let success: () -> Void
	
	public init(success: @escaping () -> Void) {
		self.success = success
	}
	
	var biometricSupported: Bool {
		biometricsContext.availableType != .none
	}

	var imageName: String {
		switch biometricsContext.biometryType {
		case .faceID: return "faceid"
		case .touchID: return "touchid"
		case _: return "lock.open"
		}
	}

	public var body: some View {
		if biometricSupported && settings.biometrics {
			KeyButton(title: Image(systemName: imageName), color: .green, textColor: .white) {
				if settings.hapticFeedback { FeedbackGenerator.impact(.rigid) }
				biometricAuthentication()
			}
		} else {
			Spacer()
		}
	}

	func biometricAuthentication() {
		let reason = "To get access to your files."
		biometricsContext.evaluatePolicy(
			.deviceOwnerAuthenticationWithBiometrics,
			localizedReason: reason
		) { success, _ in
			DispatchQueue.main.async {
				if success {
					self.success()
				} else {
					return
				}
			}
		}

	}
}

struct BiometricAuthenticationButton_Previews: PreviewProvider {
	static var previews: some View {
		BiometricAuthenticationButton {}
			.environmentObject(UserSettings())
	}
}
