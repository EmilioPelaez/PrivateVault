//
//  URLIconPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 18/3/21.
//

import SharedUI
import SwiftUI

struct URLIconPreview: View {
	let image: Image
	var body: some View {
		Color.clear
			.overlay {
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
			}
			.overlay(alignment: .bottomLeading) {
				Image(systemName: "link")
					.font(.title)
					.mediumPadding()
					.background(Color.systemBackground)
					.clipShape(Circle())
					.smallPadding()
			}
			.clipped()
	}
}

struct URLIconPreview_Previews: PreviewProvider {
	static var previews: some View {
		URLIconPreview(image: Image("file1", bundle: .gallery))
			.frame(width: 200, height: 200)
			.preparePreview()
			.previewColorSchemes()
	}
}
