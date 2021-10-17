//
//  GalleryView+Folder.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 11/08/2021.
//

import SwiftUI

extension GalleryView {
	func folderContextMenu(for folder: Folder) -> some View {
		Group {
			Button {
				currentSheet = .editFolder(folder)
			} label: {
				Text("Edit")
				Image(systemName: "square.and.pencil")
			}
			Button {
				currentSheet = .folderSelection(folder)
			} label: {
				Text("Move to Folder")
				Image(systemName: "folder.badge.plus")
			}
			Divider()
			Button {
				currentAlert = .deleteFolderConfirmation(folder)
			} label: {
				Text("Delete")
				Image(systemName: "trash")
			}
		}
	}
	
	func deleteFolder(_ folder: Folder) {
		persistenceController.delete(folder)
	}
}
