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
	@StateObject private var passcodeManager = PasscodeManager(demo: demoContent)
	@StateObject private var settings = UserSettings(demo: demoContent)
	@StateObject private var diskStore = DiskStore()
	
	public init() {}
	
	public var body: some View {
		ContentView()
			.environmentObject(passcodeManager)
			.environmentObject(diskStore)
			.environmentObject(settings)
			.persistence(demoContent ? .screenshots : .main)
			.cloudSyncStatusProvider()
			.if(demoOverrideDarkMode) { $0.colorScheme(.dark) }
			.onShakeController()
	}
}
