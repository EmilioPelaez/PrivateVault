//
//  VideoIconPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

public struct VideoIconPreview: View {
	let image: Image
	
	public init(image: Image) {
		self.image = image
	}
	
	public var body: some View {
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
		VideoIconPreview(image: Image("file1"))
			.previewLayout(.fixed(width: 200, height: 200))
		
		VideoIconPreview(image: Image("file1"))
			.previewLayout(.fixed(width: 200, height: 200))
			.colorScheme(.dark)
	}
}
