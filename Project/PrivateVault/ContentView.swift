//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 03/04/22.
//

import HierarchyResponder
import LockScreen
import Settings
import SwiftUI

struct ContentView: View {
	
	@State var showSettings = false
	
	var body: some View {
		NavigationView {
			EventButton(LockEvent()) {
				Label("Lock", systemImage: "lock.fill")
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			.navigationTitle("Vault")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showSettings = true
					}
					label: {
						Image(systemName: "gear")
					}
				}
			}
		}
		.sheet(isPresented: $showSettings) {
			SettingsScreen()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
