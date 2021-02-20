//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView: View {
	private func columns(spacing: CGFloat) -> [GridItem] {
		[
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing)
		]
	}
	
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \StoredItem.timestamp, ascending: false)], animation: .default)
	var data: FetchedResults<StoredItem>
	
	@Binding var contentMode: ContentMode
	@Binding var showDetails: Bool
	@Binding var selectedTags: Set<Tag>
	let selection: (StoredItem) -> Void
	let delete: (StoredItem) -> Void
	
	var filteredData: [StoredItem] {
		data.filter { item in
			selectedTags.reduce(true) {
				$0 && (item.tags?.contains($1) ?? false)
			}
		}
	}
	
	var body: some View {
		if data.isEmpty {
			ZStack {
				Color.clear
				EmptyGalleryView()
					.frame(maxWidth: 280)
					.transition(.opacity)
			}
		} else if filteredData.isEmpty {
			ZStack {
				Color.clear
				FilteredGalleryView {
					withAnimation {
						selectedTags = []
					}
				}
					.frame(maxWidth: 280)
					.transition(.opacity)
			}
		} else {
			ScrollView {
				LazyVGrid(columns: columns(spacing: 4), spacing: 4) {
					ForEach(filteredData) { item in
						GalleryGridCell(item: item, contentMode: $contentMode, showDetails: $showDetails)
							.onTapGesture { selection(item) }
							.contextMenu {
								Menu {
									Button(action: { delete(item) }) {
										Text("Delete")
										Image(systemName: "trash")
									}
									Button(action: { }) {
										Text("Cancel")
									}
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
		}
	}
}

struct GalleryGridView_Previews: PreviewProvider {
	static let data: [Item] = .examples
	static var previews: some View {
		EmptyView()
		//		GalleryGridView(contentMode: .constant(.fill), showDetails: .constant(true), selectedTags: .constant([])) { _ in }
		//			delete: { _ in }
		//			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
		//
		//		GalleryGridView(contentMode: .constant(.fill), showDetails: .constant(false), selectedTags: .constant([])) { _ in }
		//			delete: { _ in }
		//			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
