//
//  PersistenceController+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import Photos
import UIKit
import VisionKit

extension PersistenceController {
	
	func receiveCapturedImage(_ image: UIImage) {
		receiveImage(image, name: "New Photo", fileExtension: "jpg")
	}
	
	func receiveImage(_ image: UIImage, name: String, fileExtension: String) {
		creatingFiles = true
		storeImage(image: image, name: name, fileExtension: fileExtension) { [self] _ in
			creatingFiles = false
			save()
		}
	}
	
	func receiveScan(_ scan: VNDocumentCameraScan) {
		creatingFiles = true
		storeScan(scan, name: "Scanned Document", fileExtension: "pdf") { [self] _ in
			creatingFiles = false
			save()
		}
	}
	
	func receiveURLs(_ urls: [URL]) {
		let group = DispatchGroup()
		creatingFiles = true
		
		urls.forEach {
			group.enter()
			storeItem(at: $0) { _ in
				group.leave()
			}
		}
		
		group.notify(queue: .main) { [self] in
			creatingFiles = false
			save()
		}
	}
	
	func receiveItems(_ items: [NSItemProvider]) {
		let group = DispatchGroup()
		creatingFiles = true
		
		items.forEach {
			group.enter()
			storeItem($0) { _ in
				group.leave()
			}
		}
		
		group.notify(queue: .main) { [self] in
			creatingFiles = false
			save()
		}
	}
	
	private func storeImage(image: UIImage, name: String, fileExtension: String, completion: @escaping (Bool) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			let image = image.fixOrientation()
			let data: Data?
			if fileExtension == "png" {
				data = image.pngData()
			} else {
				data = image.jpegData(compressionQuality: 0.85)
			}
			let placeholderData = image.square(200)?.jpegData(compressionQuality: 0.85)
			guard let data = data, let placeholderData = placeholderData else {
				return DispatchQueue.main.async { completion(false) }
			}
			DispatchQueue.main.async { [self] in
				_ = StoredItem(context: context, data: data, placeholderData: placeholderData, name: name, fileExtension: fileExtension)
				save()
				completion(true)
			}
		}
	}
	
	private func storeScan(_ scan: VNDocumentCameraScan, name: String, fileExtension: String, completion: @escaping (Bool) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			let pdf = scan.generatePDF()
			let placeholder = scan.imageOfPage(at: 0).fixOrientation()
			let placeholderData = placeholder.resized(toFit: CGSize(side: 200))?.jpegData(compressionQuality: 0.85)
			let data = pdf.dataRepresentation()
			guard let data = data, let placeholderData = placeholderData else {
				return DispatchQueue.main.async { completion(false) }
			}
			DispatchQueue.main.async { [self] in
				_ = StoredItem(context: context, data: data, placeholderData: placeholderData, name: name, fileExtension: fileExtension)
				save()
				completion(true)
			}
		}
	}
	
	private func storeItem(at url: URL, completion: @escaping (Bool) -> Void) {
		guard let type = (try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier).flatMap(UTType.init) else {
			return completion(false)
		}
		storeItem(at: url, type: type, completion: completion)
	}
	
	private func storeItem(_ item: NSItemProvider, completion: @escaping (Bool) -> Void) {
		guard let typeIdentifier = item.registeredTypeIdentifiers.first, let utType = UTType(typeIdentifier) else {
			return completion(false)
		}
		item.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { [self] url, error in
			guard let url = url else {
				print(error?.localizedDescription ?? "Unknown error")
				return completion(false)
			}
			storeItem(at: url, type: utType, completion: completion)
		}
	}
	
	private func storeItem(at url: URL, type: UTType, completion: @escaping (Bool) -> Void) {
		//	TODO: Handle PDF, Video
		if type.conforms(to: .image) {
			storeImage(at: url, completion: completion)
		}
	}
	
	private func storeImage(at url: URL, completion: @escaping (Bool) -> Void) {
		guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
			return completion(false)
		}
		let name = url.deletingPathExtension().lastPathComponent
		let fileExtension = url.pathExtension
		storeImage(image: image, name: name, fileExtension: fileExtension, completion: completion)
	}
}
