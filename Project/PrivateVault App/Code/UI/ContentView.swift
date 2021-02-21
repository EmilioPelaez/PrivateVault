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
		if settings.codeLength != settings.password.count {
			SetPasscodeView { newCode, newLength in
				withAnimation {
					settings.codeLength = newLength
					settings.password = newCode
					isLocked = false
				}
			}
			.transition(.slide)
		} else {
			NavigationView {
				GalleryView(isLocked: $isLocked)
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.transition(.slide)
			.overlay(
				Group {
					GeometryReader { proxy in
						LockView(isLocked: $isLocked).offset(y: isLocked ? 0 : proxy.size.height)
					}
				}
				.animation(.linear)
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
