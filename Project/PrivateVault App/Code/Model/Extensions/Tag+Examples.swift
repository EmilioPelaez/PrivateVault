//
//  Tag+Examples.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData

extension Array where Element == Tag {
	
	static let examples: [Tag] = {
		PreviewEnvironment().tags
	}()
	
}
