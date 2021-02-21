//
//  TagListView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct TagListView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.persistenceController) private var persistenceController
	
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)], animation: .default)
	var tags: FetchedResults<Tag>
	
	@Binding var selectedTags: Set<Tag>
	@State var newTagName: String = ""
	let close: () -> Void
	
	var body: some View {
		NavigationView {
			List {
				Section(header: tagsHeader) {
					ForEach(tags) { tag in
						Button(action: { toggleTag(tag) }) {
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
						TextField("Name", text: $newTagName)
						Button(action: createTag) {
							Image(systemName: "plus.circle.fill")
								.font(.system(size: 25))
						}
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Tags")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: close) {
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
		let tag = Tag(context: viewContext)
		tag.name = newTagName
		newTagName = ""
		persistenceController?.saveContext()
	}
	
	private func deleteTags(offsets: IndexSet) {
		withAnimation {
			offsets.lazy.map { tags[$0] }.forEach {
				selectedTags.remove($0)
				viewContext.delete($0)
			}
			persistenceController?.saveContext()
		}
	}
}

struct TagListView_Previews: PreviewProvider {
	static var previews: some View {
		TagListView(selectedTags: .constant([])) { }
			.environment(\.managedObjectContext, PreviewEnvironment().context)
	}
}
