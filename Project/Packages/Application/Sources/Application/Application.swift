//
//  Application.swift
//  Application
//
//  Created by Emilio Peláez on 4/10/26.
//

import LockScreen
import Middleware
import Persistence
import Shared
import SwiftUI
import UIToolKit

public struct Application: View {
	@StateObject private var persistenceController = PersistenceManager(usage: demoContent ? .screenshots : .main)
	@StateObject private var passcodeManager = PasscodeManager(demo: demoContent)
	@StateObject private var settings = UserSettings(demo: demoContent)
	@StateObject private var diskStore = DiskStore()
	
	public init() {}
	
	public var body: some View {
		ContentView()
			.environment(\.managedObjectContext, persistenceController.container.viewContext)
			.environmentObject(persistenceController)
			.environmentObject(passcodeManager)
			.environmentObject(diskStore)
			.environmentObject(settings)
			.if(demoOverrideDarkMode) { $0.colorScheme(.dark) }
	}
}
