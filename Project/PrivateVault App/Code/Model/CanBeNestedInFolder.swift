//
//  CanBeNestedInFolder.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 11/08/2021.
//

protocol CanBeNestedInFolder {
	func belongsToFolder(_ folder: Folder) -> Bool
	func addToFolder(_ folder: Folder, persistenceController: PersistenceManager)
}

extension StoredItem: CanBeNestedInFolder {
	func belongsToFolder(_ folder: Folder) -> Bool {
		folder == self.folder
	}
	
	func addToFolder(_ folder: Folder, persistenceController: PersistenceManager) {
		self.folder = folder
		folder.items?.adding(self)
		persistenceController.save()
	}
}

extension Folder: CanBeNestedInFolder {
	func belongsToFolder(_ folder: Folder) -> Bool {
		parent == folder
	}
	
	func addToFolder(_ folder: Folder, persistenceController: PersistenceManager) {
		parent = folder
		folder.subfolders?.adding(self)
		persistenceController.save()
	}
}
