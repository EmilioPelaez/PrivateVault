//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	@State var isUnlocked = false

	var body: some View {
		NavigationView {
			GalleryView()
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.overlay(
			Group {
				if !isUnlocked {
					LockView(isUnlocked: $isUnlocked)
				}
			}
		)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
