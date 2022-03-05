//
//  PreviewEnvironment.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData
import UIKit

struct PreviewEnvironment {
	let controller: PersistenceManager
	let items: [StoredItem]
	let item: StoredItem
	let tags: [Tag]
	let folder: Folder
	let folders: [Folder]
	var context: NSManagedObjectContext { controller.container.viewContext }

	init() {
		let controller = PersistenceManager(usage: .preview)
		let viewContext = controller.container.viewContext

		let items = (1 ... 6)
			.map { $0 % 6 + 1 }
			.map { "file\($0)" }
			.compactMap { name -> StoredItem? in
				guard let image = UIImage(named: name) else { return nil }
				return StoredItem(context: viewContext, image: image, name: name, extension: "jpg", folder: nil)
			}

		let tags = ["Images", "Videos", "Documents", "Top Secret"]
			.map { Tag(context: viewContext, name: $0) }

		items[0].tags = Set(tags[1 ... 3]) as NSSet
		items[1].tags = Set(tags) as NSSet
		items[2].tags = Set(tags[0 ... 1]) as NSSet
		items[3].tags = Set(tags[2 ... 3]) as NSSet
		
		let folders = ["Images", "Videos", "Documents", "Top Secret"]
			.map { Folder(context: viewContext, name: $0, parent: nil) }

		do {
			try viewContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate.
			// You should not use this function in a shipping application,
			// although it may be useful during development.
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}

		self.controller = controller
		self.items = items
		self.item = items[0]
		self.tags = tags
		self.folder = folders[0]
		self.folders = folders
	}
}
