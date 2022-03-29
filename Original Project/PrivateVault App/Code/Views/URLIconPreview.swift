//
//  URLIconPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 18/3/21.
//

import SwiftUI

struct URLIconPreview: View {
	let image: Image
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
			Image(systemName: "link")
				.font(.system(size: 14, weight: .bold))
				.foregroundColor(.primary)
				.frame(width: 30, height: 30)
				.background(Color(.systemBackground))
				.clipShape(Circle())
				.padding(4)
		}
	}
}

struct URLIconPreview_Previews: PreviewProvider {
	static var previews: some View {
		URLIconPreview(image: Image("file1"))
			.previewLayout(.fixed(width: 200, height: 200))
		
		URLIconPreview(image: Image("file1"))
			.previewLayout(.fixed(width: 200, height: 200))
			.colorScheme(.dark)
	}
}
