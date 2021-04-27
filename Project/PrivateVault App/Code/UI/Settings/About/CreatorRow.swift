//
//  CreatorRow.swift
//  PrivateVault
//
//  Created by Ian Manor on 21/02/21.
//

import SwiftUI

struct CreatorRow: View {
	let name: String
	let title: String
	let links: [LinkType]

	var body: some View {
		HStack(spacing: 0) {
			VStack(alignment: .leading) {
				Text(name)
					.bold()
					.font(.title3)
				Text(title)
					.font(.subheadline)
			}
			Spacer()
			HStack(spacing: 4) {
				ForEach(links, id: \.systemName) { LinkButton(linkType: $0) }
			}
		}
		.padding()
		.background(Color(.tertiarySystemFill))
		.cornerRadius(15)
	}
}

struct CreatorRow_Previews: PreviewProvider {
	static var previews: some View {
		CreatorRow(name: "Bob", title: "Programmer", links: [.twitter("twitter.com/bob"), .github("github.com/bob")])
	}
}
