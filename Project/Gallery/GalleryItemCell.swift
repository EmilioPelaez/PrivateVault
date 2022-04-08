//
//  GalleryItemCell.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import SharedUI
import SwiftUI

struct GalleryItemCell: View {
	let item: GalleryItem
	
	var body: some View {
		VStack(alignment: .leading) {
			Color.clear.aspectRatio(1, contentMode: .fill)
				.overlay {
					GalleryItemPreview(kind: item.kind, image: Image("file1", bundle: .gallery))
				}
			VStack(alignment: .leading) {
				Text(item.title)
					.font(.headline)
				Text(item.subtitle)
					.lineLimit(2)
					.font(.caption)
			}
		}
	}
}

struct GalleryItemCell_Previews: PreviewProvider {
	static var previews: some View {
		GalleryItemCell(item: .init(id: "",
		                            title: "Hello There",
		                            subtitle: "General\nKenobi",
		                            kind: .folder))
			.frame(width: 200)
			.fixedSize()
			.preparePreview()
	}
}
