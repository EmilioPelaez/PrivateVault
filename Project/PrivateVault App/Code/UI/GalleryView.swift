//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct GalleryView: View {
	
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	@State var contentMode: ContentMode = .fill
	
	var data: [Item] = (1...6)
		.map { "file\($0)" }
		.map { Image($0) }
		.map(Item.init)
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(data) { item in
					Color.red.aspectRatio(1, contentMode: .fill)
						.overlay(
							item.image
								.resizable()
								.aspectRatio(contentMode: contentMode)
						)
						.clipped()
						.onTapGesture { self.display(item) }
				}
			}
		}
	}
	
	func display(_ item: Item) {
		print(item.id)
	}
	
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView()
	}
}
