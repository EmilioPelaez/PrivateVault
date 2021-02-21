//
//  EmptyGalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct EmptyGalleryView: View {
	var body: some View {
		VStack(spacing: 50) {
			Image("EmptyGallery")
				.resizable()
				.aspectRatio(CGSize(width: 765, height: 573), contentMode: .fit)
				.padding(.horizontal, 45)
			VStack(spacing: 8) {
				Text("Your gallery is empty!")
					.font(.title2)
					.multilineTextAlignment(.center)
				Text("Add some documents to get started :)")
					.multilineTextAlignment(.center)
			}
		}
		.frame(maxWidth: 300)
		.padding(.bottom, 100)
	}
}

struct EmptyGalleryView_Previews: PreviewProvider {
	static var previews: some View {
		EmptyGalleryView()
	}
}
