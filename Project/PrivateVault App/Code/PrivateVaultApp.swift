//
//  PrivateVaultApp.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

@main
struct PrivateVaultApp: App {
	@ObservedObject var persistenceController = PersistenceManager(usage: demoContent ? .screenshots : .main)
	@ObservedObject var passcodeManager = PasscodeManager(demo: demoContent)
	@ObservedObject var settings = UserSettings(demo: demoContent)
	@ObservedObject var diskStore = DiskStore()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environmentObject(persistenceController)
				.environmentObject(passcodeManager)
				.environmentObject(diskStore)
				.environmentObject(settings)
				.overrideColorScheme(override: demoOverrideDarkMode, colorScheme: .dark)
		}
	}
}
