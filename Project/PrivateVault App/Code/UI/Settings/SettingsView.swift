//
//  SettingsView.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var settings: UserSettings
	@State var resetPasscode: Bool = false
	let close: () -> Void
	let version = "0.0.1"
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Gallery view")) {
					HStack {
						Text("Columns").layoutPriority(1)
						Color.clear
						Text("\(settings.columns)")
						Stepper("") {
							settings.columns = min(8, settings.columns + 1)
						} onDecrement: {
							settings.columns = max(1, settings.columns - 1)
						}
					}
					HStack {
						Text("Show file details")
						Spacer()
						Toggle("", isOn: $settings.showDetails)
					}
				}
				Section(header: Text("Vault"), footer: footer) {
					HStack {
						Text("Attempt Limit").layoutPriority(1)
						Color.clear
						Text("\(settings.maxAttempts)")
						Stepper("", value: $settings.maxAttempts)
					}
					Button(action: { resetPasscode = true }) {
						Text("Reset Passcode")
					}
				}
				Section(header: Text("General")) {
					HStack {
						Text("Haptic Feedback")
						Spacer()
						Toggle("", isOn: $settings.hapticFeedback)
					}
					
					HStack {
						Text("Sound")
						Spacer()
						Toggle("", isOn: $settings.sound)
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Settings")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: close) {
						Image(systemName: "xmark.circle.fill")
					}
				}
			}
			.sheet(isPresented: $resetPasscode) {
				SetPasscodeView { newCode, newLength in
					settings.codeLength = newLength
					settings.passcode = newCode
					resetPasscode = false
				}
			}
		}
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
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView { }
	}
}
