//
//  Tag+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData

extension Tag {
	convenience init(context: NSManagedObjectContext, name: String) {
		self.init(context: context)
		self.name = name
	}
}
