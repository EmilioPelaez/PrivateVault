//
//  StoredItem+Example.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData
import UIKit

extension StoredItem {
	
	static let example: StoredItem = {
		let preview = PersistenceController.preview
		let filename = "file1"
		let item = StoredItem(context: preview.container.viewContext, image: UIImage(named: filename)!, filename: filename)
		return item
	}()
	
}
