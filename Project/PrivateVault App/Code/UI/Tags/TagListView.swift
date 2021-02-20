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
	
	@State var newTagName: String = ""
	let close: () -> Void
	
	var body: some View {
		NavigationView {
			List {
				Section(header: Text("All Tags")) {
					ForEach(tags) { tag in
						Text(tag.name ?? "??")
					}
					.onDelete(perform: deleteTags)
				}
				Section(header: Text("Create Tag")) {
					HStack {
						TextField("Name", text: $newTagName)
						Button(action: createTag) {
							Image(systemName: "square.and.arrow.down")
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
	
	func createTag() {
		guard !newTagName.isEmpty else { return }
		let tag = Tag(context: viewContext)
		tag.name = newTagName
		newTagName = ""
		saveContext()
	}
	
	private func deleteTags(offsets: IndexSet) {
		withAnimation {
			offsets.map { tags[$0] }.forEach(viewContext.delete)
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
		TagListView { }
			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
