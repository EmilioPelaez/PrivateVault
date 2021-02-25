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
		receiveImage(image, name: "New Photo.jpg")
	}
	
	func receiveImage(_ image: UIImage, name: String) {
		
	}
	
	func receiveScan(_ scan: VNDocumentCameraScan) {
		
	}
	
	func receiveURLs(_ url: [URL]) {
		
	}
	
	func receiveItems(_ items: [NSItemProvider]) {
		
	}
	
	func receiveItem(_ item: NSItemProvider) {
		receiveItems([item])
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
					_ = StoredItem(context: context, image: image, filename: "New photo")
				case let .photo(image, filename):
					_ = StoredItem(context: context, image: image, filename: filename)
				case let .file(url):
					_ = StoredItem(context: context, url: url)
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
