//
//  PersistenceController.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData

class PersistenceController: ObservableObject {
	let container: NSPersistentCloudKitContainer
	var context: NSManagedObjectContext { container.viewContext }
	
	init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Model")
		if inMemory {
			container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}

	func delete(_ object: NSManagedObject) {
		context.delete(object)
		save()
	}
	
	func save() {
		guard context.hasChanges else { return }
		do {
			try context.save()
		} catch {
			print(error)
		}
	}
}
