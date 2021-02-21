//
//  GalleryGridCell.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridCell: View {
	@ObservedObject var item: StoredItem
	@EnvironmentObject private var settings: UserSettings
	
	var body: some View {
		VStack(alignment: .leading) {
			Color.clear.aspectRatio(1, contentMode: .fill)
				.overlay(
					item.placeholder
						.resizable()
						.aspectRatio(contentMode: settings.contentMode)
				)
				.clipped()
			if settings.showDetails {
				VStack(alignment: .leading) {
					Text(item.name?.capping(30) ?? "Untitled")
						.font(.headline)
						.lineLimit(1)
						.foregroundColor(.secondary)
				}
				.padding([.horizontal, .bottom], 5)
			}
		}
		.background(Color(.systemBackground))
	}
}

struct GalleryGridCell_Previews: PreviewProvider {
	static var previews: some View {
		GalleryGridCell(item: .example)
			.previewLayout(.fixed(width: 200, height: 300))
		GalleryGridCell(item: .example)
			.previewLayout(.fixed(width: 200, height: 200))
	}
}
