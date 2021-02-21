//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.scenePhase) private var scenePhase
	@State var isLocked = true
	
	var body: some View {
		NavigationView {
			GalleryView(isLocked: $isLocked)
		}
		.navigationViewStyle(StackNavigationViewStyle())
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

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
