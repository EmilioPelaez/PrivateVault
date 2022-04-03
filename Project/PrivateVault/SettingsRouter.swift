//
//  SettingsRouter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 03/04/22.
//

import Settings
import SwiftUI

struct SettingsRouter: ViewModifier {
	@State var showSettings = false
	
	func body(content: Content) -> some View {
		content
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showSettings = true
					}
					label: {
						Image(systemName: "gear")
					}
				}
			}
			.sheet(isPresented: $showSettings) {
				SettingsScreen()
			}
	}
}

extension View {
	func settingsRouter() -> some View {
		modifier(SettingsRouter())
	}
}
