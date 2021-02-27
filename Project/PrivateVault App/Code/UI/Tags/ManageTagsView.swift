//
//  ManageTagsView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct ManageTagsView: View {
	@EnvironmentObject private var persistenceController: PersistenceController
	@Environment(\.presentationMode) var presentationMode

	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)], animation: .default)
	var tags: FetchedResults<Tag>

	@ObservedObject var filter: ItemFilter
	
	@State var newTagName: String = ""
	@State var duplicateNameAlert = false

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Create Tag")) {
					HStack {
						TextField("Enter Name", text: $newTagName)
						Button(action: createTag) {
							Image(systemName: "plus.circle.fill")
								.font(.system(size: 25))
						}
					}
				}
				Section(header: Text("All Tags")) {
					ForEach(tags) { tag in
						HStack {
							Text(tag.name ?? "??")
								.foregroundColor(.primary)
							Spacer()
						}
					}
					.onDelete(perform: deleteTags)
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
			.alert(isPresented: $duplicateNameAlert) {
				Alert(title: Text("Tag Already Exists"), message: Text("Choose a unique name for your tag."), dismissButton: .default(Text("Ok!")))
			}
		}
	}

	func createTag() {
		let newTagName = newTagName.trimmingCharacters(in: .whitespaces)
		guard !newTagName.isEmpty else { return }
		guard !tags.contains(where: { $0.name == newTagName }) else {
			duplicateNameAlert = true
			return
		}
		let tag = Tag(context: persistenceController.context)
		tag.name = newTagName
		self.newTagName = ""
		persistenceController.save()
	}

	private func deleteTags(offsets: IndexSet) {
		let deletedTags = offsets.map { tags[$0] }
		filter.deleted(deletedTags)
		withAnimation {
			deletedTags.forEach {
				persistenceController.delete($0)
			}
		}
	}
}

struct TagListView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		ManageTagsView(filter: .preview(with: preview))
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.environmentObject(UserSettings())
	}
}
