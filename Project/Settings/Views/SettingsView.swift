//
//  SettingsView.swift
//  Settings
//
//  Created by Emilio Peláez on 03/04/22.
//

import HierarchyResponder
import SwiftUI

struct SettingsView: View {
	@Environment(\.biometricsState) var biometricsState
	@EnvironmentObject private var settings: UserSettings
	
	var body: some View {
		Form {
			Section(header: Text("Security")) {
				if biometricsState.available {
					Toggle(isOn: $settings.biometrics) {
						Label(biometricsState.name, systemImage: biometricsState.imageName)
					}
				}
				HStack {
					Stepper(value: $settings.maxAttempts, in: 1 ... 10) {
						Label("Attempt Limit", systemImage: "\(settings.maxAttempts).circle")
					}
				}
				EventButton(ResetPasscodeEvent()) {
					Label("Reset Passcode", systemImage: "rectangle.and.pencil.and.ellipsis")
				}
			}
			Section(header: Text("General")) {
				Toggle(isOn: $settings.sound) {
					Label("Sound", systemImage: settings.sound ? "speaker.wave.3" : "speaker")
				}
				Toggle(isOn: $settings.hapticFeedback) {
					Label("Haptic Feedback",
					      systemImage: settings.hapticFeedback ? "iphone.radiowaves.left.and.right" : "iphone")
				}
			}
			Section(header: Text("Legal")) {
				NavigationLink(destination: AboutView()) {
					Text("About")
				}
				NavigationLink(destination: LicenseView()) {
					Text("License")
				}
				NavigationLink(destination: PrivacyView()) {
					Text("Privacy")
				}
			}
			
			//				Section(header: DirectoryFeaturedView.title) {
			//					DirectoryFeaturedView(client: client, style: .groupedList) {}
			//				}
		}
		.listStyle(InsetGroupedListStyle())
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
			.environmentObject(UserSettings())
			.preparePreview()
	}
}
