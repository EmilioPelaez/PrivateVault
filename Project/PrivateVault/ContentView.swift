//
//  ContentView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 03/04/22.
//

import ActionButtons
import HierarchyResponder
import LockScreen
import Settings
import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
			EventButton(LockEvent()) {
				Label("Lock", systemImage: "lock.fill")
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			.navigationTitle("Vault")
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarLeading) {
					EventButton(LockEvent()) {
						Image(systemName: "lock")
					}
					EventButton(ShowSettingsEvent()) {
						Image(systemName: "gear")
					}
				}
			}
			.extend()
			.overlay(alignment: .bottomLeading) {
				ImportSelectionView()
					.largePadding()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
