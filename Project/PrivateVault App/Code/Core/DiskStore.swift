//
//  DiskStore.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 2/3/21.
//

import Combine
import Foundation

class DiskStore: ObservableObject {
	
	enum StoreError: Swift.Error {
		case missingId
		case missingData
		case missingName
		case missingExtension
		case writingFailed
	}
	
	struct Item: Identifiable {
		let stored: StoredItem
		let url: URL
		
		var id: String? { stored.id }
	}
	
	func url(for item: StoredItem, in folder: URL = FileManager.default.temporaryDirectory) throws -> URL {
		guard let id = item.id else { throw StoreError.missingId }
		guard let fileExtension = item.fileExtension else { throw StoreError.missingExtension }
		var url = folder.appendingPathComponent(id)
		if let name = item.name {
			url = url.appendingPathComponent(name)
		}
		url = url.appendingPathExtension(fileExtension)
		return url
	}
	
	func add(_ item: StoredItem, completion: @escaping (Result<Item, Error>) -> Void) {
		_addItem(item).receive(on: RunLoop.main).result(handler: completion).store(in: &bag)
	}
	
	func add(_ items: [StoredItem], completion: @escaping ([Result<Item, Error>]) -> Void) {
		var results: [Result<Item, Error>] = []
		
		let group = DispatchGroup()
		let queue = DispatchQueue(label: "ArrayAppend", attributes: .concurrent)
		
		items.map(_addItem).forEach {
			group.enter()
			$0.result { result in
				queue.async(flags: .barrier) {
					results.append(result)
				}
				group.leave()
			}
				.store(in: &bag)
		}
		
		group.notify(queue: .main) {
			completion(results)
		}
	}
	
	func remove(_ item: Item) {
		remove(item.stored)
	}
	
	func remove(_ item: StoredItem) {
		guard let id = item.id else { return }
		guard let diskItem = stored[id] else { return }
		diskItem.references -= 1
		if diskItem.references == 0 {
			stored.removeValue(forKey: id)
			cleanup(for: diskItem)
		}
	}
	
	private func _addItem(_ item: StoredItem) -> AnyPublisher<Item, Error> {
		guard let id = item.id else {
			return Fail<Item, Error>(error: StoreError.missingId).eraseToAnyPublisher()
		}
		if let diskItem = stored[id] {
			diskItem.references += 1
			return diskItem.task.map { Item(stored: item, url: $0) }.eraseToAnyPublisher()
		}
		
		do {
			let diskItem = try createDiskItem(for: item)
			return diskItem.task.map { Item(stored: item, url: $0) }.eraseToAnyPublisher()
		} catch {
			return Fail<Item, Error>(error: error).eraseToAnyPublisher()
		}
	}
	
	private class DiskItem {
		enum State {
			case inProgress
			case completed
		}
		
		var references: Int
		var state: State
		var task: AnyPublisher<URL, Error>
		
		init(task: AnyPublisher<URL, Error>) {
			self.references = 1
			self.state = .inProgress
			self.task = task
		}
	}
	
	private var stored: [String: DiskItem] = [:]
	private let queue = DispatchQueue(label: "DiskStore", qos: .userInitiated)
	private var bag: Set<AnyCancellable> = []
	
	private func createDiskItem(for item: StoredItem) throws -> DiskItem {
		guard let id = item.id else { throw StoreError.missingId }
		if let diskItem = stored[id] { return diskItem }
		let task = Future<URL, Error> { [self] promise in
			queue.async {
				do {
					let fileUrl = try url(for: item)
					try FileManager.default.createDirectory(at: fileUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
					try? FileManager.default.removeItem(at: fileUrl)
					guard let data = item.data else {
						throw StoreError.missingData
					}
					try data.write(to: fileUrl)
					if let diskItem = stored[id] {
						diskItem.task = Just(fileUrl)
							.setFailureType(to: Error.self)
							.eraseToAnyPublisher()
					}
					promise(.success(fileUrl))
				} catch {
					promise(.failure(error))
				}
			}
		}
		.eraseToAnyPublisher()
		let diskItem = DiskItem(task: task)
		stored[id] = diskItem
		return diskItem
	}
	
	private func cleanup(for item: DiskItem) {
		item.task
			.tryMap { try FileManager.default.removeItem(at: $0) }
			.result { _ in }
			.store(in: &bag)
	}
	
}
