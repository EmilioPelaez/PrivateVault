//
//  StoredItem+Nestable.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/10/21.
//

import Foundation

extension StoredItem: Nestable {
	func belongs(to folder: Folder) -> Bool {
		folder == self.folder
	}
	
	func canBelong(to folder: Folder) -> Bool {
		true
	}
	
	func add(to folder: Folder, persistenceController: PersistenceManager) {
		self.folder = folder
		folder.items?.adding(self)
		persistenceController.save()
	}
	
	func remove(from _: Folder, persistenceController: PersistenceManager) {
		folder = nil
		persistenceController.save()
	}
}
