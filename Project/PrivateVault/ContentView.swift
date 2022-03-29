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
		InputDisplay(input: "AB", codeLength: 4)
			.extend()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
