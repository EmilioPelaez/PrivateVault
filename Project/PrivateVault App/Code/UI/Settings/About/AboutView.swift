//
//  AboutView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

struct AboutView: View {
	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			VStack(spacing: 0) {
				HStack(alignment: .top, spacing: 20) {
					Image("Icon")
						.resizable()
						.frame(width: 120, height: 120)
						.clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
					VStack(alignment: .leading, spacing: 8) {
						Text("Capsule")
							.bold()
							.font(.title)
						Text("Version 0.0.1")
							.font(.subheadline)
					}
					.padding(.top, 10)
					Spacer()
				}
				.padding()
				VStack(alignment: .leading, spacing: 8) {
					CreatorRow(name: "Emilio Peláez", title: "Programmer", links: [
						.website("http://emiliopelaez.me"),
						.twitter("http://twitter.com/EmilioPelaez"),
						.appStore("https://apps.apple.com/us/developer/emilio-pelaez/id408763858")
					])
					CreatorRow(name: "Ian Manor", title: "Programmer", links: [
						.website("https://www.ianmanor.com/portfolio"),
						.twitter("https://twitter.com/ian_manor"),
						.github("https://www.github.com/imvm")
					])
					CreatorRow(name: "Daniel Behar", title: "Programmer", links: [
						.twitter("https://twitter.com/dannybehar"),
						.github("https://github.com/DannyBehar")
					])
				}
				.padding()
			}
		}
		.navigationTitle("About")
	}
}

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
