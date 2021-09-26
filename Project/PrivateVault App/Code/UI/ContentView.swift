//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject private var appState = AppState()
	@Environment(\.scenePhase) private var scenePhase
	@EnvironmentObject private var settings: UserSettings
	@EnvironmentObject private var passcodeManager: PasscodeManager
	@State var isLocked = true

	var body: some View {
		if !passcodeManager.passcodeSet {
			SetPasscodeView { newCode, newLength in
				withAnimation {
					passcodeManager.passcodeLength = newLength
					passcodeManager.passcode = newCode
					isLocked = false
				}
			}
			.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
		} else {
			NavigationView {
				GalleryView(isLocked: $isLocked)
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
			.overlay(
				Group {
					if isLocked {
						LockView(isLocked: $isLocked)
							.transition(.asymmetric(insertion: .opacity, removal: .move(edge: .bottom)))
					}
				}
			)
			.onChange(of: scenePhase) { phase in
				if [.inactive, .background].contains(phase) {
					isLocked = true
				}
			}
			.environmentObject(appState)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		ContentView()
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.environmentObject(UserSettings())
			.environmentObject(PasscodeManager())
	}
}
