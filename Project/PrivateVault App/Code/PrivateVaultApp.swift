//
//  PrivateVaultApp.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

@main
struct PrivateVaultApp: App {
	@ObservedObject var settings = UserSettings()
	@ObservedObject var persistenceController = PersistenceController()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environmentObject(settings)
				.environmentObject(persistenceController)
		}
	}
}
