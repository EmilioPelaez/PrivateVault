//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView: View {
	@EnvironmentObject private var settings: UserSettings
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \StoredItem.timestamp, ascending: false)], animation: .default)
	var data: FetchedResults<StoredItem>
	
	@ObservedObject var filter: ItemFilter
	
	@State var tagEditingItem: StoredItem?
	let selection: (StoredItem) -> Void
	let delete: (StoredItem) -> Void

	var filteredData: [StoredItem] {
		data.filter(filter.apply)
	}
	
	var searchText: Binding<String> {
		Binding(get: {
			filter.searchText
		}, set: {
			filter.searchText = $0
		})
	}

	var body: some View {
		if data.isEmpty {
			VStack {
				SearchBarView(text: searchText, placeholder: "Search files...")
				ZStack {
					Color.clear
					EmptyGalleryView()
						.frame(maxWidth: 280)
						.transition(.opacity)
				}
			}
		} else if filteredData.isEmpty {
			VStack {
				SearchBarView(text: searchText, placeholder: "Search files...")
				ZStack {
					Color.clear
					FilteredGalleryView {
						withAnimation { filter.clear() }
					}
					.frame(maxWidth: 280)
					.transition(.opacity)
				}
			}
		} else {
			ScrollView {
				SearchBarView(text: searchText, placeholder: "Search files...")
				LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: settings.columns), spacing: 4) {
					ForEach(filteredData) { item in
						GalleryGridCell(item: item)
							.onTapGesture { selection(item) }
							.contextMenu {
								Button {
									tagEditingItem = item
								} label: {
									Text("Edit")
									Image(systemName: "pencil")
								}
								Button {
									delete(item)
								} label: {
									Text("Delete")
									Image(systemName: "trash")
								}
							}
					}
				}
				.padding(4)
				.padding(.bottom, 55)
			}
			.popover(item: $tagEditingItem) { item in
				ItemEditView(item: item) { tagEditingItem = nil }
			}
		}
	}
}

struct GalleryGridView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		EmptyView()
		GalleryGridView(filter: ItemFilter()) { _ in } delete: { _ in }
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.environmentObject(UserSettings())
	}
}
