//
//  EditFolderView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 17/07/2021.
//

import SwiftUI

struct EditFolderView: View {
	@ObservedObject var folder: Folder
	@EnvironmentObject private var persistenceController: PersistenceManager
	@Environment(\.presentationMode) var presentationMode
	@State private var folderName = ""
	@State private var duplicateNameAlert = false
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)],
		animation: .default
	) private var folders: FetchedResults<Folder>
	
	var body: some View {
		NavigationView {
			List {
				TextField(folder.name ?? "Enter Name", text: $folderName)
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Edit Folder")
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					saveButton
				}
				ToolbarItem(placement: .cancellationAction) {
					cancelButton
				}
			}
			.alert(isPresented: $duplicateNameAlert) {
				Alert(title: Text("Folder Already Exists"), message: Text("Choose a unique name for your folder."), dismissButton: .default(Text("Ok!")))
			}
		}
	}
}

extension EditFolderView {
	var cancelButton: some View {
		Button("Cancel") {
			presentationMode.wrappedValue.dismiss()
		}
	}
	
	var saveButton: some View {
		Button("Save") {
			guard !folderName.isEmpty else { return }
			guard !folders.contains(where: { $0.name == folderName }) else {
				duplicateNameAlert = true
				return
			}
			folder.name = folderName
			persistenceController.save()
			presentationMode.wrappedValue.dismiss()
		}
	}
}

struct EditFolderView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		EditFolderView(folder: preview.folder)
	}
}
