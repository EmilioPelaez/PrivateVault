//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView<E>: View where E: View {
	private func columns(spacing: CGFloat) -> [GridItem] {
		[
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing)
		]
	}
	
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \StoredItem.timestamp, ascending: false)], animation: .default)
	var data: FetchedResults<StoredItem>

	@State var searchText = ""
	@Binding var contentMode: ContentMode
	@Binding var showDetails: Bool
	let emptyView: E
	let selection: (StoredItem) -> Void
	let delete: (StoredItem) -> Void
	
	var body: some View {
		if data.isEmpty {
			ZStack {
				Color.clear
				emptyView
					.frame(maxWidth: 280)
			}
		} else {
			ScrollView {
			SearchBarView(text: $searchText, placeholder: "Search files...")
			LazyVGrid(columns: columns(spacing: 4), spacing: 4) {
				ForEach(data) { item in
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
		GalleryGridView(contentMode: .constant(.fill), showDetails: .constant(true), emptyView: Color.red) { _ in }
			delete: { _ in }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
		
		GalleryGridView(contentMode: .constant(.fill), showDetails: .constant(false), emptyView: Color.red) { _ in }
			delete: { _ in }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
