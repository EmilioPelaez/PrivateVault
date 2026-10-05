//
//  EditFolderView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 17/07/2021.
//

import CoreData
import Persistence
import SwiftUI

public struct EditFolderView: View {
	@ObservedObject var folder: Folder
	@EnvironmentObject private var persistenceController: PersistenceManager
	@Environment(\.presentationMode) var presentationMode
	@State private var folderName = ""
	@State private var duplicateNameAlert = false
	
	public init(folder: Folder) {
		self.folder = folder
	}
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)],
		animation: .default
	) private var folders: FetchedResults<Folder>
	
	public var body: some View {
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

public extension EditFolderView {
	@ViewBuilder
	var cancelButton: some View {
		if #available(iOS 26.0, *) {
			Button(role: .cancel, action: cancel)
		} else {
			Button("Cancel", action: cancel)
		}
	}
	
	@ViewBuilder
	var saveButton: some View {
		if #available(iOS 26.0, *) {
			Button(role: .confirm, action: save)
		} else {
			Button("Save", action: save)
		}
	}
	
	func cancel() {
		presentationMode.wrappedValue.dismiss()
	}
	
	func save() {
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

struct EditFolderView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		EditFolderView(folder: preview.folder)
	}
}
