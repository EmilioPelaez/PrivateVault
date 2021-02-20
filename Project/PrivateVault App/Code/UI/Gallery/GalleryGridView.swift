//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView: View {
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	@Binding var data: [Item]
	@Binding var contentMode: ContentMode
	let selection: (Item) -> Void
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(data) { item in
					VStack {
						Color.red.aspectRatio(1, contentMode: .fill)
							.overlay(
								item.image
									.resizable()
									.aspectRatio(contentMode: contentMode)
							)
							.clipped()
							.onTapGesture { selection(item) }
						Text("pup.jpg")
							.font(.headline)
						Text("12/31/20")
							.font(.footnote)
							.foregroundColor(.secondary)
						Text("5.9 MB")
							.font(.footnote)
							.foregroundColor(.secondary)
					}
				}
			}
		}
	}
}

struct GalleryGridView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryGridView(data: .constant([]), contentMode: .constant(.fill)) { _ in }
	}
}
