//
//  SettingsView.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var settings: UserSettings
	let close: () -> Void
	let version = "0.0.1"

	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Gallery view")) {
					HStack {
						Text("Show file details")
						Spacer()
						Toggle("", isOn: $settings.showDetails)
					}
					Picker("Content mode", selection: $settings.contentMode) {
						ForEach(ContentMode.allCases, id: \.self) {
							Text($0.description)
						}
					}
				}
				Section(footer: footer) {
					Text("...")
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
