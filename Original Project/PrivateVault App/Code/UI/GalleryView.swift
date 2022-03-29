//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct GalleryView: View {
	@State var contentMode: ContentMode = .fill
	@State var selectedItem: Item?

	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible()),
		]
	}

	var data: [Item] = (1 ... 6)
		.map { "file\($0)" }
		.compactMap { UIImage(named: $0) }
		.map(Item.init)

	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(data) { item in
					Color.red.aspectRatio(1, contentMode: .fill)
						.overlay(
							item.placeholder
								.resizable()
								.aspectRatio(contentMode: contentMode)
						)
						.clipped()
						.onTapGesture {}
				}
			}
		}
		.navigation(item: $selectedItem, destination: quickLookView)
	}

	@ViewBuilder
	func quickLookView(_ item: Item) -> some View {
		QuickLookView(title: item.id.description, url: URL(string: ""))
	}
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView()
	}
}
