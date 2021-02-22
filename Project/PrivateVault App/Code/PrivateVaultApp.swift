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
	let persistenceController = PersistenceController()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environment(\.persistenceController, persistenceController)
				.environmentObject(settings)
		}
	}
}
