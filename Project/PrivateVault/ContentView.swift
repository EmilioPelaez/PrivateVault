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
import ActionButtons

struct ContentView: View {
	var body: some View {
		NavigationView {
			EventButton(LockEvent()) {
				Label("Lock", systemImage: "lock.fill")
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			.navigationTitle("Vault")
			.extend()
			.overlay(alignment: .bottomLeading) {
				ImportSelectionView()
					.largePadding()
			}
			.settingsRouter()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
