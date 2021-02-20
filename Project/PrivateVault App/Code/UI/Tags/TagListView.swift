//
//  TagListView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct TagListView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
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
						HStack {
							Text(tag.name ?? "??")
							Spacer()
							ZStack {
								Circle()
									.stroke(Color.blue, lineWidth: 2)
									.frame(width: 24, height: 24)
								Circle()
									.fill(Color.blue)
									.frame(width: 20, height: 20)
									.scaleEffect(selectedTags.contains(tag) ? 1 : 0)
							}
						}
						.onTapGesture { toggleTag(tag) }
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
		saveContext()
	}
	
	private func deleteTags(offsets: IndexSet) {
		
		withAnimation {
			offsets.lazy.map { tags[$0] }.forEach {
				selectedTags.remove($0)
				viewContext.delete($0)
			}
			saveContext()
		}
	}
	
	private func saveContext() {
		do {
			try viewContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
}

struct TagListView_Previews: PreviewProvider {
	static var previews: some View {
		TagListView(selectedTags: .constant([])) { }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
