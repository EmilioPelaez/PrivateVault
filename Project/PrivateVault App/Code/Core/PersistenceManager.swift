//
//  AppPersistenceManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import Combine
import CoreData

class PersistenceManager: ObservableObject {
	private let operationQueue = ObservableOperationQueue()
	let container: NSPersistentContainer
	var context: NSManagedObjectContext { container.viewContext }
	
	@Published private(set) var ready = false
	@Published var creatingFiles = false
	@Published var errorString: String?
	@Published var fatalErrorString: String?
	var importErrors: [ImportError] = []
	
	var bag: Set<AnyCancellable> = []
	
	enum Usage {
		case main
		case preview
		case importExtension
		case screenshots
	}
	
	convenience init(usage: Usage) {
		switch usage {
		case .main:
			self.init(modelName: "Model", cloudKitIdentifier: "iCloud.com.emiliopelaez.Private-Vault", baseUrl: .container, inMemory: false)
		case .preview:
			self.init(modelName: "Model", inMemory: true)
		case .importExtension:
			self.init(modelName: "Model", baseUrl: .container)
			operationQueue.maxConcurrentOperationCount = 1
		case .screenshots:
			self.init(modelName: "Model", baseUrl: Bundle.main.bundleURL)
		}
		
		combine()
	}
	
	private init(modelName: String, model: NSManagedObjectModel? = nil, storeName: String? = nil, cloudKitIdentifier: String? = nil, baseUrl: URL? = nil, readOnly: Bool = false, inMemory: Bool = false) {
		
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
		
		description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
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
	
	private func combine() {
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
	
	func flushErrors() {
		importErrors = []
	}
}
