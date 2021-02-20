//
//  GalleryGridCell.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridCell: View {
	@EnvironmentObject private var settings: UserSettings
	let item: StoredItem
	
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
					Text(item.name ?? "??")
						.font(.headline)
//					Text("12/31/20")
//						.font(.footnote)
//						.foregroundColor(.secondary)
					Text(String(format: "%.1f MB", CGFloat(item.data?.count ?? 0) / 1_000_000))
						.font(.footnote)
						.foregroundColor(.secondary)
				}
			}
		}
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
