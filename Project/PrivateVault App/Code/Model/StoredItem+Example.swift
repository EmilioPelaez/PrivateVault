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
		let item = StoredItem(context: preview.container.viewContext, image: UIImage(named: "file1")!)
		return item
	}()
	
}
