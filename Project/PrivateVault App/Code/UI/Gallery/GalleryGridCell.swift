//
//  GalleryGridCell.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridCell: View {
	enum Selection {
		case disabled
		case unselected
		case selected
	}
	
	@ObservedObject var item: StoredItem
	@EnvironmentObject private var settings: UserSettings

	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()
	
	let selection: Selection
	
	var body: some View {
		VStack(alignment: .leading) {
			ZStack(alignment: .topTrailing) {
				Color.clear.aspectRatio(1, contentMode: .fill)
					.overlay(
						ItemPreview(item: item)
					)
					.clipped()
				ItemSelectionView(selected: selection == .selected)
					.padding(6)
					.opacity(selection == .disabled ? 0 : 1)
			}
			if settings.showDetails {
				VStack(alignment: .leading, spacing: 4) {
					Text(item.name ?? "Untitled")
						.font(.headline)
						.lineLimit(1)
						.foregroundColor(.primary)
					Group {
						if let date = item.timestamp {
							Text(date, formatter: GalleryGridCell.dateFormatter)
						} else {
							Text("No Date")
						}
					}
					.font(.caption)
					.lineLimit(1)
					.foregroundColor(Color(.secondaryLabel))
					Text(String(format: "%.2f MB", Double(item.data?.count ?? 0) / 1_000_000))
						.font(.caption2)
						.lineLimit(1)
						.foregroundColor(Color(.secondaryLabel))
				}
				.padding([.horizontal, .bottom], 5)
			}
		}
		.background(Color(.systemBackground))
	}
}

struct GalleryGridCell_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		GalleryGridCell(item: preview.item, selection: .disabled)
			.previewLayout(.fixed(width: 200, height: 300))
			.environmentObject(UserSettings())
		
		GalleryGridCell(item: preview.item, selection: .disabled)
			.previewLayout(.fixed(width: 200, height: 200))
			.environmentObject(UserSettings())
	}
}
