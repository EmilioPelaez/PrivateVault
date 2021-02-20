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
			KeypadView(input: { _ in }, delete: { isUnlocked = true })
				.navigation(isPresenting: $isUnlocked, destination: GalleryView())
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
