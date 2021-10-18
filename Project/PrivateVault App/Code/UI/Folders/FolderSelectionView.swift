//
//  FolderSelectionView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 05/08/2021.
//

import SwiftUI

struct FolderSelectionView: View {
	let item: Nestable
	
	@EnvironmentObject private var persistenceController: PersistenceManager
	@Environment(\.presentationMode) var presentationMode
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)],
		predicate: NSPredicate(format: "parent == nil"),
		animation: .default
	) private var folders: FetchedResults<Folder>
	
	var body: some View {
		NavigationView {
			Group {
				if folders.isEmpty {
					VStack {
						FolderShape()
							.folderStyle()
							.frame(width: 25, height: 25)
						Text("No Folders")
							.foregroundColor(.secondary)
							.font(.headline)
					}
				} else {
					List(Array(folders), children: \.children) { folder in
						FolderListItem(name: folder.name ?? "Untitled Folder",
						               isSelected: item.belongs(to: folder),
						               isSelectable: item.canBelong(to: folder)) {
							didSelectFolder(folder)
						}
					}
				}
			}
			
			.navigationTitle("Add to Folder")
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
	
	func didSelectFolder(_ folder: Folder) {
		if item.belongs(to: folder) {
			item.remove(from: folder)
		} else {
			item.add(to: folder)
		}
		persistenceController.save()
	}
}

struct FolderSelectionView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		FolderSelectionView(item: preview.item)
	}
}
