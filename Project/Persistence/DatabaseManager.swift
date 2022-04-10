//
//  DatabaseManager.swift
//  Persistence
//
//  Created by Emilio Peláez on 09/04/22.
//

import Combine
import CoreData

public class DatabaseManager: ObservableObject {
	let container: NSPersistentContainer
	var context: NSManagedObjectContext { container.viewContext }
	
	@Published private(set) var ready = false
	@Published var errorString: String?
	@Published var fatalErrorString: String?
	
	public init(modelName: String = "Model",
	            model: NSManagedObjectModel? = nil,
	            storeName: String? = nil,
	            cloudKitIdentifier: String? = nil,
	            baseUrl: URL? = nil,
	            readOnly: Bool = false,
	            inMemory: Bool = false) {
		
		if let model = model, cloudKitIdentifier != nil {
			self.container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: model)
		} else if let model = model {
			self.container = NSPersistentContainer(name: modelName, managedObjectModel: model)
		} else if cloudKitIdentifier != nil {
			self.container = NSPersistentCloudKitContainer(name: modelName)
		} else {
			self.container = NSPersistentContainer(name: modelName)
		}
		
		if let baseUrl = baseUrl ?? (inMemory ? URL(fileURLWithPath: "/dev/null") : nil) {
			let storeUrl = baseUrl.appendingPathComponent(storeName ?? modelName).appendingPathExtension("sqlite")
			let description = NSPersistentStoreDescription(url: storeUrl)
			description.isReadOnly = readOnly
			
			container.persistentStoreDescriptions = [description]
		}
		
		guard let description = container.persistentStoreDescriptions.first else {
			assertionFailure("Container has no description")
			return
		}
		
		if let cloudKitIdentifier = cloudKitIdentifier {
			description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: cloudKitIdentifier)
		}
		
		//	swiftlint:disable:next legacy_objc_type
		description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
		//	swiftlint:disable:next legacy_objc_type
		description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				self.fatalErrorString = error.localizedDescription
			}
			self.ready = true
		}
		
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.transactionAuthor = "App"
		container.viewContext.automaticallyMergesChangesFromParent = true
		do {
			try container.viewContext.setQueryGenerationFrom(.current)
		} catch {
			assertionFailure("Failed to pin viewContext to the current generation: \(error)")
		}
	}
}
