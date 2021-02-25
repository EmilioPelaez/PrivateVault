//
//  TagListView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct TagListView: View {
	@EnvironmentObject private var persistenceController: PersistenceController
	@Environment(\.presentationMode) var presentationMode

	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)], animation: .default)
	var tags: FetchedResults<Tag>

	@Binding var selectedTags: Set<Tag>
	@State var newTagName: String = ""

	var body: some View {
		NavigationView {
			List {
				Section(header: tagsHeader) {
					ForEach(tags) { tag in
						Button {
							toggleTag(tag)
						} label: {
							HStack {
								Text(tag.name ?? "??")
									.foregroundColor(.primary)
								Spacer()
								RadioButton(selected: selectedTags.contains(tag), size: 24, color: .blue)
							}
						}
					}
					.onDelete(perform: deleteTags)
				}
				Section(header: Text("Create Tag")) {
					HStack {
						TextField("Enter Name", text: $newTagName)
						Button(action: createTag) {
							Image(systemName: "plus.circle.fill")
								.font(.system(size: 25))
						}
						.disabled(tags.contains { $0.name == newTagName })
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Tags")
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

	var tagsHeader: some View {
		HStack {
			Text("All Tags")
			Spacer()
			Text("Filter")
				.padding(.trailing, 15)
		}
	}

	func toggleTag(_ tag: Tag) {
		withAnimation {
			if selectedTags.contains(tag) {
				selectedTags.remove(tag)
			} else {
				selectedTags.insert(tag)
			}
		}
	}

	func createTag() {
		guard !newTagName.isEmpty else { return }
		let tag = Tag(context: persistenceController.context)
		tag.name = newTagName
		newTagName = ""
		persistenceController.save()
	}

	private func deleteTags(offsets: IndexSet) {
		withAnimation {
			offsets.lazy.map { tags[$0] }.forEach {
				selectedTags.remove($0)
				persistenceController.delete($0)
			}
		}
	}
}

struct TagListView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		TagListView(selectedTags: .constant([]))
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.environmentObject(UserSettings())
	}
}
