//
//  Tag+Comparable.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData

extension Tag: Comparable {
	public static func < (lhs: Tag, rhs: Tag) -> Bool {
		lhs.name ?? "" < rhs.name ?? ""
	}
}
