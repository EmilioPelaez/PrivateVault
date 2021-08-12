//
//  FolderSelectionView.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 05/08/2021.
//

import SwiftUI

struct FolderSelectionView: View {
	let item: CanBeNestedInFolder
	
	@EnvironmentObject private var persistenceController: PersistenceManager
	@Environment(\.presentationMode) var presentationMode
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)],
		animation: .default
	) private var folders: FetchedResults<Folder>
	
	var body: some View {
		NavigationView {
			List(folders) { folder in
				FolderListItem(name: folder.name ?? "Unknown",
							   isSelected: item.belongsToFolder(folder)) {
					item.addToFolder(folder, persistenceController: persistenceController)
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
}

struct FolderSelectionView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
    static var previews: some View {
		FolderSelectionView(item: preview.item)
    }
}
