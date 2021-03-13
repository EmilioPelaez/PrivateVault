//
//  SettingsDetailRow.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/3/21.
//

import SwiftUI

struct SettingsDetailRow<Content: View>: View {
	var label: String
	var content: () -> (Content)

	var body: some View {
		NavigationLink(destination: destination) {
			HStack {
				Text(label)
				Spacer()
			}
		}
	}

	var destination: some View {
		ScrollView {
			ZStack(alignment: .topLeading) {
				Color.clear
				content()
			}
			.padding()
		}
		.navigationBarTitle(label, displayMode: .inline)
	}
}

struct SettingsDetailRow_Previews: PreviewProvider {
	static var previews: some View {
		SettingsDetailRow(label: "Hello") {
			Text("World")
		}
	}
}
