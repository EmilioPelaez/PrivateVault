//
//  Folder+Nestable.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/10/21.
//

import Foundation

extension Folder: Nestable {
	public func belongs(to folder: Folder) -> Bool {
		parent == folder
	}
	
	public func canBelong(to folder: Folder) -> Bool {
		if folder == self { return false }
		guard let parent = folder.parent else { return true }
		return canBelong(to: parent)
	}
	
	public func add(to folder: Folder) {
		parent = folder
		folder.subfolders?.adding(self)
	}
	
	public func remove(from folder: Folder) {
		guard parent == folder else { return }
		parent = nil
	}
}
