//
//  SettingsPrivacyView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 14/3/21.
//

import SwiftUI

struct PrivacyView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 15) {
				Text("This app lets your keep your sensitive data away from prying eyes that might have access to your device.")
					.multilineTextAlignment(.leading)
				//	swiftlint:disable:next line_length
				Text("This app, however, doesn't or offer encryption or protection beyond what a 4/6-digit pin can provide. A highly technical attacker could, in theory, have access to the data stored in this app if they had physical access to your device.")
					.multilineTextAlignment(.leading)
				Text("Your data is only stored in your device and your own personal iCloud storage, if available.")
					.multilineTextAlignment(.leading)
				Text("You can find the source code for this app here:")
					.multilineTextAlignment(.leading)
				Button {
					guard let url = URL(string: "https://github.com/EmilioPelaez/PrivateVault") else { return }
					UIApplication.shared.open(url)
				}
				label: {
					Text("View Source Code")
				}
			}
			.frame(maxWidth: .infinity)
			.padding()
		}
		.navigationBarTitle("Privacy", displayMode: .inline)
	}
}

struct PrivacyView_Previews: PreviewProvider {
	static var previews: some View {
		PrivacyView()
	}
}
