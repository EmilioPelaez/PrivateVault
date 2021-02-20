//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	@State var password = "12345"
	@State var code = ""
	@State var isUnlocked = false
	var isIncorrect: Bool { code.count == password.count && code != password }

	var body: some View {
		NavigationView {
			KeypadView(code: $code, maxDigits: 5, isIncorrect: isIncorrect)
				.navigation(isPresenting: $isUnlocked, destination: GalleryView())
				.navigationBarHidden(true)
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onChange(of: code) { _ in
			if code == password {
				code = ""
				isUnlocked = true
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
