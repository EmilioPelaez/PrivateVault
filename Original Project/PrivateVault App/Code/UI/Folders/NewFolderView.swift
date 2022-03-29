//
//  FolderEditView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 17/07/2021.
//

import SwiftUI

struct NewFolderView: View {
	
	@EnvironmentObject private var appState: AppState
	@EnvironmentObject private var persistenceController: PersistenceManager
	@Environment(\.presentationMode) var presentationMode
	@State private var folderName: String = ""
	@State private var duplicateNameAlert = false
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)],
		animation: .default
	) private var folders: FetchedResults<Folder>
	
	var body: some View {
		NavigationView {
			List {
				TextField("Enter Name", text: $folderName)
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("New Folder")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
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

extension NewFolderView {
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
			_ = Folder(context: persistenceController.context, name: folderName, parent: appState.currentFolder)
			persistenceController.save()
			presentationMode.wrappedValue.dismiss()
		}
	}
}

struct NewFolderView_Previews: PreviewProvider {
	static var previews: some View {
		NewFolderView()
	}
}
