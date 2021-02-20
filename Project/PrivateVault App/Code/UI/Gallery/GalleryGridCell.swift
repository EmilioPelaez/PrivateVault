//
//  GalleryGridCell.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridCell: View {
	let item: Item
	@Binding var contentMode: ContentMode
	let selection: (Item) -> Void
	
	var body: some View {
		VStack(alignment: .leading) {
			Color.clear.aspectRatio(1, contentMode: .fill)
				.overlay(
					item.image
						.resizable()
						.aspectRatio(contentMode: contentMode)
				)
				.clipped()
				.onTapGesture { selection(item) }
			VStack(alignment: .leading) {
				Text("pup.jpg")
					.font(.headline)
				Text("12/31/20")
					.font(.footnote)
					.foregroundColor(.secondary)
				Text("5.9 MB")
					.font(.footnote)
					.foregroundColor(.secondary)
			}
			.padding(.horizontal, 8)
		}
	}
}

struct GalleryGridCell_Previews: PreviewProvider {
	static var previews: some View {
		GalleryGridCell(item: Item(image: Image("file1")), contentMode: .constant(.fill)) { _ in }
			.previewLayout(.fixed(width: 200, height: 280))
	}
}
