//
//  VideoPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct VideoPreview: View {
	let image: Image
	var body: some View {
		ZStack {
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
			Image(systemName: "play.fill")
				.font(.title)
				.foregroundColor(.black)
				.padding(12)
				.background(Color.white)
				.clipShape(Circle())
				.shadow(color: Color(white: 0, opacity: 0.1), radius: 4, x: 0, y: 2)
		}
	}
}

struct VideoPreview_Previews: PreviewProvider {
	static var previews: some View {
		VideoPreview(image: Image("file1"))
			.previewLayout(.fixed(width: 200, height: 200))
		
		VideoPreview(image: Image("file1"))
			.previewLayout(.fixed(width: 200, height: 200))
			.colorScheme(.dark)
	}
}
