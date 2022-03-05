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
	
	func canBelong(to _: Folder) -> Bool {
		true
	}
	
	func add(to folder: Folder) {
		self.folder = folder
		folder.items?.adding(self)
	}
	
	func remove(from folder: Folder) {
		guard self.folder == folder else { return }
		self.folder = nil
	}
}
