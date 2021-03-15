//
//  PrivateVaultApp.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

@main
struct PrivateVaultApp: App {
	@ObservedObject var persistenceController = PersistenceManager()
	@ObservedObject var passcodeManager = PasscodeManager()
	@ObservedObject var settings = UserSettings()
	@ObservedObject var diskStore = DiskStore()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environmentObject(persistenceController)
				.environmentObject(passcodeManager)
				.environmentObject(diskStore)
				.environmentObject(settings)
		}
	}
}
