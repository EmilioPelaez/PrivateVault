//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 30/03/22.
//

import LockScreen
import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack(spacing: .paddingMedium) {
			InputDisplay(input: "AB", codeLength: 4)
				.tint(.primary)
			KeypadView()
		}
		.frame(maxWidth: .keypadMaxWidth)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
