//
//  ItemEditView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct ItemEditView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)], animation: .default)
	var tags: FetchedResults<Tag>
	
	@ObservedObject var item: StoredItem
	let close: () -> Void
	
	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Name")) {
					TextField("Name", text: .init(get: { item.name ?? "" },
																				set: { item.name = $0 }))
				}
				Section(header: Text("Tags")) {
					ForEach(tags) { tag in
						HStack {
							Text(tag.name ?? "??")
							Spacer()
							RadioButton(selected: tagSelected(tag), size: 20, color: .blue, action: { })
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
						.onTapGesture {
							toggleTag(tag)
						}
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Edit")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: close) {
						Image(systemName: "xmark.circle.fill")
					}
				}
			}
		}
	}
	
	func tagSelected(_ tag: Tag) -> Bool {
		item.tags?.contains(tag) ?? false
	}
	
	func toggleTag(_ tag: Tag) {
		withAnimation {
			if tagSelected(tag) {
				item.removeFromTags(tag)
			} else {
				item.addToTags(tag)
			}
		}
	}
}

struct ItemTagsView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		ItemEditView(item: preview.item) { }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
			.previewLayout(.sizeThatFits)
	}
}
