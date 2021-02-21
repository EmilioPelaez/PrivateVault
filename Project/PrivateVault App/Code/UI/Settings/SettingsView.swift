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
	let license = """
	MIT License

	Copyright (c) 2021 Emilio Peláez

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	"""
	
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
				Section(header: Text("Vault")) {
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
				Section(header: Text("Legal"), footer: footer) {
					SettingsDetailRow(label: "Privacy", text: "PrivateVault does not upload any user data.")
					SettingsDetailRow(label: "License", text: license)
					SettingsDetailRow(label: "About", text: "Created by Emilio, Danny and Ian.")
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

struct SettingsDetailRow: View {
	var label: String
	var text: String

	var body: some View {
		NavigationLink(destination: destination) {
			HStack {
				Text(label)
				Spacer()
			}
		}
	}

	var destination: some View {
		ScrollView {
			VStack {
				HStack {
					Text(text).multilineTextAlignment(.leading)
					Spacer()
				}
				Spacer()
			}
		}
		.padding()
		.navigationBarTitle(label, displayMode: .inline)
	}
}
