//
//  Folder+Creation.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 06/08/2021.
//

import CoreData

extension Folder {
	convenience init(context: NSManagedObjectContext, name: String) {
		self.init(context: context)
		self.name = name
	}
}

extension Folder {
	var children: [Folder]? {
		let array = subfolders?.allObjects
		if array?.isEmpty == true {
			return nil
		} else {
			return array  as? [Folder]
		}
	}
}
