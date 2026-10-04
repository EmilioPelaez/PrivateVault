//
//  PreviewEnvironment.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CGMath
import CoreData
import UIKit

public struct PreviewEnvironment {
	public let controller: PersistenceManager
	public let items: [StoredItem]
	public let item: StoredItem
	public let tags: [Tag]
	public let folder: Folder
	public let folders: [Folder]
	public var context: NSManagedObjectContext { controller.container.viewContext }
	
	public init() {
		let controller = PersistenceManager(usage: .preview)
		let viewContext = controller.container.viewContext

		let items = (1 ... 6)
			.map { $0 % 6 + 1 }
			.map { "file\($0)" }
			.map { name -> StoredItem in
				let image = UIImage(named: name) ?? .placeholder
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

private extension UIImage {
	//	The preview images live in the app target, this is used when previewing from a package
	static var placeholder: UIImage {
		UIGraphicsImageRenderer(size: CGSize(side: 200)).image { context in
			UIColor.systemTeal.setFill()
			context.fill(CGRect(origin: .zero, size: CGSize(side: 200)))
		}
	}
}
