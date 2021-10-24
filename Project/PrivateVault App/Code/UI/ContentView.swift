//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject private var appState = AppState()
	@StateObject private var filter = ItemFilter()
	@Environment(\.scenePhase) private var scenePhase
	@EnvironmentObject private var settings: UserSettings
	@EnvironmentObject private var passcodeManager: PasscodeManager

	var body: some View {
		if !passcodeManager.passcodeSet {
			SetPasscodeView { newCode, newLength in
				withAnimation {
					passcodeManager.passcodeLength = newLength
					passcodeManager.passcode = newCode
					appState.isLocked = false
				}
			}
			.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
		} else {
			NavigationView {
				GalleryView(isLocked: $appState.isLocked)
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
			.overlay(
				Group {
					if appState.isLocked {
						LockView(isLocked: $appState.isLocked)
							.transition(.asymmetric(insertion: .opacity, removal: .move(edge: .bottom)))
					}
				}
			)
			.onChange(of: scenePhase) { phase in
				if [.inactive, .background].contains(phase) {
					appState.isLocked = true
				}
				if phase == .active, !appState.attemptedToShowReviewPrompt {
					ReviewPromptManager()?.trigger()
					appState.attemptedToShowReviewPrompt = true
				}
			}
			.environmentObject(appState)
			.environmentObject(filter)
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
			.environmentObject(AppState())
	}
}
