//
//  SettingsView.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

struct SettingsView: View {
	let close: () -> Void
	let version = "0.0.1"

	var body: some View {
		NavigationView {
			Form {
				Section {
					Text("First Setting")
				}
				Section {
					Text("Second Setting")
				}
				Section(footer: footer) {
					Text("Third Setting")
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
