//
//  SettingsView.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

struct SettingsView: View {
	let close: () -> Void

	var body: some View {
		NavigationView {
			Form {
				Section {
					Text("First Setting")
				}
				Section {
					Text("Second Setting")
				}
				Section {
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
}
