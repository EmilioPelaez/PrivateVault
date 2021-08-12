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
