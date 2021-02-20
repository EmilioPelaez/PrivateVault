//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView: View {
	func columns(spacing: CGFloat) -> [GridItem] {
		[
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing)
		]
	}
	
	@FetchRequest(sortDescriptors: [], animation: .default)
	var data: FetchedResults<StoredItem>
	
	@Binding var contentMode: ContentMode
	@Binding var showDetails: Bool
	let selection: (StoredItem) -> Void
	let delete: (StoredItem) -> Void
	
	var body: some View {
		ScrollView {
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

struct GalleryGridView_Previews: PreviewProvider {
	static let data: [Item] = .examples
	static var previews: some View {
		GalleryGridView(contentMode: .constant(.fill), showDetails: .constant(true)) { _ in }
			delete: { _ in }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

		GalleryGridView(contentMode: .constant(.fill), showDetails: .constant(false)) { _ in }
			delete: { _ in }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
