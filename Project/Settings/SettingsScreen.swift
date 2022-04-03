//
//  SettingsScreen.swift
//  Settings
//
//  Created by Emilio Peláez on 03/04/22.
//

import LockScreen
import SwiftUI

public struct SettingsScreen: View {
	@Environment(\.presentationMode) var presentationMode
	
	public init() {}
	
	public var body: some View {
		NavigationView {
			SettingsView()
			.navigationTitle("Settings")
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
}

struct SettingsScreen_Previews: PreviewProvider {
	static var previews: some View {
		SettingsScreen()
			.settingsProvider()
	}
}
