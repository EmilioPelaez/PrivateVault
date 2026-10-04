//
//  StoredItem+Nestable.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/10/21.
//

import Foundation

extension StoredItem: Nestable {
	public func belongs(to folder: Folder) -> Bool {
		folder == self.folder
	}
	
	public func canBelong(to _: Folder) -> Bool {
		true
	}
	
	public func add(to folder: Folder) {
		self.folder = folder
		folder.items?.adding(self)
	}
	
	public func remove(from folder: Folder) {
		guard self.folder == folder else { return }
		self.folder = nil
	}
}
