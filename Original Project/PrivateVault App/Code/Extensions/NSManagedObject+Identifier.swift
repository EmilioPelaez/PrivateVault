//
//  NSManagedObject+Identifier.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 12/10/21.
//

import CoreData

extension NSManagedObject {
	var identifier: String {
		objectID.uriRepresentation().absoluteString
	}
}
