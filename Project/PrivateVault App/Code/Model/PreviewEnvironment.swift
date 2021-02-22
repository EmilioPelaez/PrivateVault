//
//  PreviewEnvironment.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData
import SwiftUI
import UIKit

struct PreviewEnvironment {
	let controller: PersistenceController
	let items: [StoredItem]
	let item: StoredItem
	let tags: [Tag]
	var context: NSManagedObjectContext { controller.container.viewContext }

	init() {
		let controller = PersistenceController(inMemory: true)
		let viewContext = controller.container.viewContext

		let items = (1...6)
			.map { $0 % 6 + 1 }
			.map { "file\($0)" }
			.compactMap { name -> StoredItem? in
				guard let image = UIImage(named: name) else { return nil }
				return StoredItem(context: viewContext, image: image, filename: name + ".png")
			}

		let tags = ["Images", "Videos", "Documents", "Top Secret"]
			.map { Tag(context: viewContext, name: $0) }

		items[0].tags = Set(tags[1...3]) as NSSet
		items[1].tags = Set(tags) as NSSet
		items[2].tags = Set(tags[0...1]) as NSSet
		items[3].tags = Set(tags[2...3]) as NSSet

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
	}
}
