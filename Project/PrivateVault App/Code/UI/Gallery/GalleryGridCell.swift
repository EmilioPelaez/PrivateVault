//
//  GalleryGridCell.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridCell: View {
	@ObservedObject var item: StoredItem
	@Binding var contentMode: ContentMode
	@Binding var showDetails: Bool
	
	var body: some View {
		VStack(alignment: .leading) {
			Color.clear.aspectRatio(1, contentMode: .fill)
				.overlay(
					item.placeholder
						.resizable()
						.aspectRatio(contentMode: contentMode)
				)
				.clipped()
			if showDetails {
				VStack(alignment: .leading) {
					Text(item.name ?? "??")
						.font(.headline)
						.lineLimit(1)
				}
				.padding([.horizontal, .bottom], 5)
			}
		}
		.background(Color(.systemBackground))
	}
}

struct GalleryGridCell_Previews: PreviewProvider {
	static var previews: some View {
		GalleryGridCell(item: .example, contentMode: .constant(.fill), showDetails: .constant(true))
			.previewLayout(.fixed(width: 200, height: 300))
		GalleryGridCell(item: .example, contentMode: .constant(.fill), showDetails: .constant(false))
			.previewLayout(.fixed(width: 200, height: 200))
	}
}
