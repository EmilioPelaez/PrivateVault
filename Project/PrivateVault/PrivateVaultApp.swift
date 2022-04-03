//
//  PrivateVaultApp.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 30/03/22.
//

import LockScreen
import SwiftUI

@main
struct PrivateVaultApp: App {
	var body: some Scene {
		WindowGroup {
			LockRouter()
				.appLockResponder()
		}
	}
}
