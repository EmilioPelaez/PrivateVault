//
//  LinkButton.swift
//  PrivateVault
//
//  Created by Ian Manor on 21/02/21.
//

import SwiftUI

struct LinkButton: View {
	let linkType: LinkType

	var body: some View {
		Button {
			guard let url = URL(string: linkType.urlString) else { return }
			UIApplication.shared.open(url)
		}
			label: {
				Image(systemName: linkType.systemName)
					.frame(width: 40, height: 40)
					.background(linkType.color)
					.cornerRadius(20)
					.foregroundColor(.white)
					.font(.system(size: linkType.size, weight: .regular, design: .default))
			}
	}
}

struct LinkButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			LinkButton(linkType: .twitter("twitter.com/bob"))
			LinkButton(linkType: .github("github.com/bob"))
			LinkButton(linkType: .appStore("apple.com/bob"))
			LinkButton(linkType: .website("bob.com"))
		}
		.preparePreview()
		.previewColorSchemes()
	}
}
