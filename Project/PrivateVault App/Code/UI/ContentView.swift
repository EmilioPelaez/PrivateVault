//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct ContentView: View {
	@State var password = "123"
	@State var code = ""
	var isUnlocked: Bool { code == password }

	var body: some View {
		NavigationView {
			KeypadView(code: $code, maxDigits: 5)
				.navigation(
					isPresenting: .init(get: { isUnlocked }, set: { _ in }),
					destination: GalleryView()
				)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
