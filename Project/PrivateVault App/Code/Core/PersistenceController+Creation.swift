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
		print(#function)
		storeImage(image: image, name: name, fileExtension: fileExtension) { _ in
			self.creatingFiles = false
			print("Done!")
		}
	}
	
	func receiveScan(_ scan: VNDocumentCameraScan) {
		creatingFiles = true
		print(#function)
		storeScan(scan, name: "Scanned Document", fileExtension: "pdf") { _ in
			self.creatingFiles = false
			print("Done!")
		}
	}
	
	func receiveURLs(_ url: [URL]) {
		
	}
	
	func receiveItems(_ items: [NSItemProvider]) {
		
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
			}
		}
	}
	
	private enum ItemType {
		case photo(UIImage, String)
		case capture(UIImage)
		case file(URL)
	}
	
	private func createItem(_ item: ItemType) {
		createItems([item])
	}
	
	private func createItems(_ items: [ItemType]) {
		creatingFiles = true
		DispatchQueue.global(qos: .userInitiated).async { [self] in
			items.forEach {
				switch $0 {
				case let .capture(image):
					break
//					_ = StoredItem(context: context, image: image, filename: "New photo")
				case let .photo(image, filename):
					break
//					_ = StoredItem(context: context, image: image, filename: filename)
				case let .file(url):
					break
//					_ = StoredItem(context: context, url: url)
				}
			}
			DispatchQueue.main.async { [self] in
				creatingFiles = false
				save()
			}
		}
	}
	
	func loadData(from itemProviders: [NSItemProvider]) {
		itemProviders.forEach(loadData)
	}
	
	func loadData(from itemProvider: NSItemProvider) {
		guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
					let utType = UTType(typeIdentifier)
		else { return }
		
		itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { [self] url, error in
			if let error = error {
				print(error.localizedDescription)
			}
			
			guard let url = url else {
				print("Failed to get url")
				return
			}
			
			if utType.conforms(to: .image) {
				getPhoto(from: itemProvider, url: url)
			} else if utType.conforms(to: .movie) {
				getVideo(from: url)
			} else if utType.conforms(to: .livePhoto) {
				getPhoto(from: itemProvider, url: url, isLivePhoto: true)
			}
		}
	}
	
	private func getPhoto(from itemProvider: NSItemProvider, url: URL, isLivePhoto: Bool = false) {
		let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
		
		if itemProvider.canLoadObject(ofClass: objectType) {
			itemProvider.loadObject(ofClass: objectType) { object, error in
				if let error = error {
					print(error.localizedDescription)
				}
				
				if !isLivePhoto {
					if let image = object as? UIImage {
//						selectItem(.photo(image.fixOrientation(), url.lastPathComponent))
						// self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: image))
					}
				} else {
					if let livePhoto = object as? PHLivePhoto {
						print(livePhoto)
						// self.parent.selectImage(livePhoto, "filename")
						// self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: livePhoto))
					}
				}
			}
		}
	}
	
	private func getVideo(from url: URL) {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
		
		do {
			if FileManager.default.fileExists(atPath: targetURL.path) {
				try FileManager.default.removeItem(at: targetURL)
			}
			
			try FileManager.default.copyItem(at: url, to: targetURL)
			
//			selectItem(.file(targetURL))
		} catch {
			print(error.localizedDescription)
		}
	}
}
