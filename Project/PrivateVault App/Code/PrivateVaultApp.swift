//
//  PrivateVaultApp.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

@main
struct PrivateVaultApp: App {
	let persistenceController = PersistenceController()
	@ObservedObject var settings = UserSettings()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environmentObject(settings)
		}
	}
}
