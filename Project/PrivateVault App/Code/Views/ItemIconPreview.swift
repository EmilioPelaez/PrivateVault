//
//  ItemIconPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct ItemIconPreview: View {
	let image: Image
	let type: StoredItem.DataType
	var body: some View {
		ZStack {
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
			Image(systemName: type.overlaySystemImageName)
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
		ItemIconPreview(image: Image("file1"), type: .video)
			.previewLayout(.fixed(width: 200, height: 200))
		
		ItemIconPreview(image: Image("file1"), type: .url)
			.previewLayout(.fixed(width: 200, height: 200))
			.colorScheme(.dark)
	}
}
