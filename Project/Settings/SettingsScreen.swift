//
//  SettingsScreen.swift
//  Settings
//
//  Created by Emilio Peláez on 03/04/22.
//

import LockScreen
import SharedUI
import SwiftUI

public struct SettingsScreen: View {
	@Environment(\.dismiss) var dismiss
	
	public init() {}
	
	public var body: some View {
		NavigationView {
			SettingsView()
				.navigationTitle("Settings")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						ModalDismissButton(dismiss)
					}
				}
				.changePasscodeRouter()
		}
	}
}

struct SettingsScreen_Previews: PreviewProvider {
	static var previews: some View {
		SettingsScreen()
			.settingsProvider()
	}
}
