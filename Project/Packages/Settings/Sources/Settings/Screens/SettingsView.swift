//
//  SettingsView.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import LocalAuthentication
import LockScreen
import Middleware
import SwiftUI

public struct SettingsView: View {
	@EnvironmentObject private var settings: UserSettings
	@EnvironmentObject private var passcodeManager: PasscodeManager
	@Environment(\.presentationMode) var presentationMode

	let biometricsContext = LAContext()

	@State var resetPasscode: Bool = false
	let version = "1.0"
	
	public init() {}
	
	var biometricSupported: Bool {
		biometricsContext.availableType != .none
	}

	var biometricTitle: String {
		switch biometricsContext.availableType {
		case .faceID: return "Face ID"
		case .touchID: return "Touch ID"
		case _: return ""
		}
	}

	public var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Security")) {
					if biometricSupported {
						HStack {
							Text(biometricTitle)
							Spacer()
							Toggle("", isOn: $settings.biometrics)
						}
					}
					HStack {
						Stepper(value: $settings.maxAttempts, in: 1 ... 10) {
							HStack {
								Text("Attempt Limit")
								Text("\(settings.maxAttempts)")
							}
						}
					}
					Button {
						resetPasscode = true
					} label: {
						HStack {
							Text("Reset Passcode")
								.foregroundColor(.primary)
							Spacer()
							Image(systemName: "chevron.right")
								.font(.footnote.weight(.semibold))
								.foregroundColor(Color(.tertiaryLabel))
						}
					}
				}
				Section(header: Text("General")) {
					Toggle(isOn: $settings.sound) {
						Text("Sound")
					}
					Toggle(isOn: $settings.hapticFeedback) {
						Text("Haptic Feedback")
					}
				}
				Section(header: Text("Legal")) {
					NavigationLink(destination: AboutView()) {
						Text("About")
					}
					NavigationLink(destination: SettingsLicenseView()) {
						Text("License")
					}
					NavigationLink(destination: SettingsPrivacyView()) {
						Text("Privacy")
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Settings")
			.navigationDestination(isPresented: $resetPasscode) { resetView }
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						presentationMode.wrappedValue.dismiss()
					}
					label: {
						Image(systemName: "xmark.circle.fill")
					}
				}
			}
		}
	}
	
	var resetView: some View {
		SetPasscodeView { newCode, newLength in
			passcodeManager.passcodeLength = newLength
			passcodeManager.passcode = newCode
			resetPasscode = false
		}
		.navigationBarTitle(Text("Reset"), displayMode: .inline)
	}

	var footer: some View {
		HStack {
			Spacer()
			Text("Version \(version)")
				.font(.footnote)
				.foregroundColor(Color(.secondaryLabel))
			Spacer()
		}
	}

	func requestBiometric() {
		let context = LAContext()
		var error: NSError?

		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
		} else {
			return
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
			.environmentObject(UserSettings())
			.environmentObject(PasscodeManager())
	}
}
