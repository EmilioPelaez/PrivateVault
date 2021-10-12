//
//  Folder+Nestable.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/10/21.
//

import Foundation

extension Folder: Nestable {
	func belongs(to folder: Folder) -> Bool {
		parent == folder
	}
	
	func canBelong(to folder: Folder) -> Bool {
		if folder == self { return false }
		guard let parent = folder.parent else { return true }
		return canBelong(to: parent)
	}
	
	func add(to folder: Folder, persistenceController: PersistenceManager) {
		parent = folder
		folder.subfolders?.adding(self)
		persistenceController.save()
	}
	
	func remove(from _: Folder, persistenceController: PersistenceManager) {
		parent = nil
		persistenceController.save()
	}
}
