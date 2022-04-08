//
//  VideoIconPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SharedUI
import SwiftUI

struct VideoIconPreview: View {
	let image: Image
	var body: some View {
		ZStack {
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
			Image(systemName: "play.fill")
				.font(.system(size: 25, weight: .medium))
				.foregroundColor(.white)
				.frame(width: 50, height: 50)
				.background(Color(white: 0, opacity: 0.5))
				.clipShape(Circle())
		}
	}
}

struct VideoPreview_Previews: PreviewProvider {
	static var previews: some View {
		VideoIconPreview(image: Image("file1", bundle: .gallery))
			.frame(width: 200, height: 200)
			.preparePreview()
	}
}
