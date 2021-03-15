//
//  PersistenceController.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import Combine
import CoreData

class PersistenceController: ObservableObject {
	let container: NSPersistentCloudKitContainer
	var context: NSManagedObjectContext { container.viewContext }
	private let operationQueue = ObservableOperationQueue()
	
	@Published var creatingFiles = false
	@Published var errorString: String?
	@Published var fatalErrorString: String?
	
	var bag: Set<AnyCancellable> = []
	
	init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Model")
		if inMemory {
			container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
		}
		
		guard let description = container.persistentStoreDescriptions.first else {
			assertionFailure("Container has no description")
			return
		}
		
		description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.emiliopelaez.Private-Vault")
		
		description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
		description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				self.fatalErrorString = error.localizedDescription
			}
		}
		
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.transactionAuthor = "App"
		container.viewContext.automaticallyMergesChangesFromParent = true
		do {
			try container.viewContext.setQueryGenerationFrom(.current)
		} catch {
			assertionFailure("Failed to pin viewContext to the current generation: \(error)")
		}
		
		combine()
	}
	
	func combine() {
		operationQueue.$isRunning.assign(to: &$creatingFiles)
		operationQueue.$isRunning
			.dropFirst()
			.filter { !$0 }
			.map { _ in }
			.sink { [weak self] in self?.save() }
			.store(in: &bag)
	}
	
	func addOperation(block: @escaping (@escaping () -> Void) -> Void) {
		let operation = AsynchronousOperation(block: block)
		operationQueue.addOperation(operation)
	}
}
