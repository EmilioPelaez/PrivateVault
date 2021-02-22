//
//  PersistenceController.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData

struct PersistenceController {
	let container: NSPersistentCloudKitContainer

	init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Model")
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				// TODO: Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate.
				// You should not use this function in a shipping application, although it may be useful during development.

				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
	}

	func saveContext() {
		do {
			try container.viewContext.save()
		} catch {
			//	TODO: Error Handling
			print(error)
		}
	}
}
