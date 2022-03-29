//
//  FolderNavigationViewViewModel.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 29/10/21.
//

import Foundation

extension FolderNavigationView {
	struct ViewModel {
		static let empty = ViewModel(currentFolder: nil)
		
		let currentFolder: Folder?
		let intermediaryFolders: [Folder]
		
		init(currentFolder: Folder?) {
			guard let currentFolder = currentFolder else {
				self.currentFolder = nil
				self.intermediaryFolders = []
				return
			}
			self.currentFolder = currentFolder
			var intermediaryFolders: [Folder] = []
			var currentParent = currentFolder
			while let parent = currentParent.parent {
				intermediaryFolders.append(parent)
				currentParent = parent
			}
			self.intermediaryFolders = intermediaryFolders.reversed()
		}
	}
}
