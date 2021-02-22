//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.scenePhase) private var scenePhase
	@EnvironmentObject private var settings: UserSettings
	@State var isLocked = true

	var body: some View {
		if settings.codeLength != settings.passcode.count {
			SetPasscodeView { newCode, newLength in
				withAnimation {
					settings.codeLength = newLength
					settings.passcode = newCode
					isLocked = false
				}
			}
			.transition(.move(edge: .trailing))
		} else {
			NavigationView {
				GalleryView(isLocked: $isLocked)
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.transition(.move(edge: .leading))
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
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
