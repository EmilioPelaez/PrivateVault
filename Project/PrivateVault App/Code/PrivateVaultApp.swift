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
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.environment(\.persistenceController, persistenceController)
		}
	}
}
