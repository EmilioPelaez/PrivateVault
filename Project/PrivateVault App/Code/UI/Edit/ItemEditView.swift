//
//  ItemEditView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct ItemEditView: View {
	@EnvironmentObject private var persistenceController: PersistenceController
	@Environment(\.presentationMode) var presentationMode
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)], animation: .default)
	var tags: FetchedResults<Tag>

	@ObservedObject var item: StoredItem

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Name")) {
					TextField("Name", text: $item.name.default(""))
				}
				Section(header: Text("Tags")) {
					ForEach(tags) { tag in
						Button {
							toggleTag(tag)
						} label: {
							HStack {
								Text(tag.name ?? "??")
									.foregroundColor(.primary)
								Spacer()
								RadioButton(selected: tagSelected(tag), size: 20, color: .blue)
							}
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Edit")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						presentationMode.wrappedValue.dismiss()
					}
					label: {
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
		persistenceController.save()
	}
}

struct ItemTagsView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()

	static var previews: some View {
		ItemEditView(item: preview.item)
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.previewLayout(.sizeThatFits)
	}
}
