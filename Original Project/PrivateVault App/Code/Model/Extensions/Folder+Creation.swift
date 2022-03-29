//
//  Folder+Creation.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 06/08/2021.
//

import CoreData

extension Folder {
	convenience init(context: NSManagedObjectContext, name: String, parent: Folder?) {
		self.init(context: context)
		self.name = name
		self.parent = parent
	}
}

extension Folder {
	//	swiftlint:disable:next discouraged_optional_collection
	var children: [Folder]? {
		subfolders?.allObjects as? [Folder]
	}
}
