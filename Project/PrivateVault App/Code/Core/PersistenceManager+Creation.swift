//
//  PersistenceManager+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import AVFoundation
import LinkPresentation
import Photos
import QuickLook
import UIKit
import VisionKit

extension PersistenceManager {
	var previewSize: CGFloat {
		min(UIScreen.main.bounds.width / 2, 500)
	}
	
	func receiveCapturedImage(_ image: UIImage) {
		receiveImage(image, name: "New Photo", fileExtension: "jpg")
	}
	
	func receiveImage(_ image: UIImage, name: String, fileExtension: String) {
		addOperation { [self] complete in
			storeImage(image: image, name: name, fileExtension: fileExtension) { _ in
				complete()
			}
		}
	}
	
	func receiveScan(_ scan: VNDocumentCameraScan) {
		addOperation { [self] complete in
			storeScan(scan, name: "Scanned Document", fileExtension: "pdf") { _ in
				complete()
			}
		}
	}
	
	func receiveURLs(_ urls: [URL]) {
		urls.forEach { [self] url in
			addOperation { complete in
				storeItem(at: url) { _ in
					complete()
				}
			}
		}
	}
	
	func receiveItems(_ items: [NSItemProvider]) {
		items.forEach { [self] item in
			addOperation { complete in
				storeItem(item) { _ in
					complete()
				}
			}
		}
	}
	
	private func storeImage(image: UIImage, name: String, fileExtension: String, completion: @escaping (Bool) -> Void) {
		let image = image.fixOrientation()
		let data: Data?
		if fileExtension == "png" {
			data = image.pngData()
		} else {
			data = image.jpegData(compressionQuality: 0.85)
		}
		let previewData = image.square(previewSize)?.jpegData(compressionQuality: 0.85)
		guard let data = data, let previewData = previewData else {
			return DispatchQueue.main.async { completion(false) }
		}
		DispatchQueue.main.async { [self] in
			_ = StoredItem(context: context, data: data, previewData: previewData, type: .image, name: name, fileExtension: fileExtension)
			save()
			completion(true)
		}
	}
	
	private func storeScan(_ scan: VNDocumentCameraScan, name: String, fileExtension: String, completion: @escaping (Bool) -> Void) {
		let pdf = scan.generatePDF()
		let preview = scan.imageOfPage(at: 0).fixOrientation()
		let previewData = preview.resized(toFit: CGSize(side: previewSize))?.jpegData(compressionQuality: 0.85)
		let data = pdf.dataRepresentation()
		guard let data = data, let previewData = previewData else {
			return DispatchQueue.main.async { completion(false) }
		}
		DispatchQueue.main.async { [self] in
			_ = StoredItem(context: context, data: data, previewData: previewData, type: .file, name: name, fileExtension: fileExtension)
			save()
			completion(true)
		}
	}
	
	private func storeItem(at url: URL, completion: @escaping (Bool) -> Void) {
		guard let type = (try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier).flatMap(UTType.init) else {
			return completion(false)
		}
		storeItem(at: url, type: type, completion: completion)
	}
	
	private func storeItem(_ item: NSItemProvider, completion: @escaping (Bool) -> Void) {
		guard let typeIdentifier = item.registeredTypeIdentifiers.first, let type = UTType(typeIdentifier) else {
			return completion(false)
		}
		guard !type.conforms(to: .url) else {
			_ = item.loadObject(ofClass: URL.self) { [self] url, error in
				guard let url = url else {
					print(error?.localizedDescription ?? "Unknown error")
					return completion(false)
				}
				storeRemoteUrl(url, completion: completion)
			}
			return
		}
		item.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { [self] url, error in
			guard let url = url else {
				print(error?.localizedDescription ?? "Unkown error")
				return completion(false)
			}
			guard FileManager.default.fileExists(atPath: url.absoluteString) else {
				return storeItemFallback(item, url: url, type: type, completion: completion)
			}
			storeItem(at: url, type: type, completion: completion)
		}
	}
	
	//	If NSItemProvider fails to provide a file at the given URL, but can provide the data, 
	private func storeItemFallback(_ item: NSItemProvider, url: URL, type: UTType, completion: @escaping (Bool) -> Void) {
		item.loadDataRepresentation(forTypeIdentifier: type.identifier) { [self] data, error in
			guard let data = data else {
				print(error?.localizedDescription ?? "Unkown error")
				return completion(false)
			}
			do {
				let folder = FileManager.default.temporaryDirectory.appendingPathComponent("temp")
				let newURL = folder
					.appendingPathComponent(url.lastPathComponent)
				try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
				try data.write(to: newURL)
				
				storeItem(at: newURL, type: type, completion: completion)
			} catch {
				print("Error", error)
				completion(false)
			}
		}
	}
	
	private func storeItem(at url: URL, type: UTType, completion: @escaping (Bool) -> Void) {
		if type.conforms(to: .image) {
			storeImage(at: url, completion: completion)
		} else if type.conforms(to: .audiovisualContent) {
			storeVideo(at: url, completion: completion)
		} else if type.isSupported {
			storeFile(at: url, completion: completion)
		} else {
			completion(false)
		}
	}
	
	private func storeImage(at url: URL, completion: @escaping (Bool) -> Void) {
		guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
			return completion(false)
		}
		storeImage(image: image, name: url.filename, fileExtension: url.pathExtension, completion: completion)
	}
	
	private func storeVideo(at url: URL, completion: @escaping (Bool) -> Void) {
		guard let data = try? Data(contentsOf: url) else {
			return completion(false)
		}
		let previewGenerator = AVAssetImageGenerator(asset: AVAsset(url: url))
		previewGenerator.appliesPreferredTrackTransform = true
		let cgImage = try? previewGenerator.copyCGImage(at: .zero, actualTime: nil)
		let image = cgImage.map(UIImage.init)?.square(previewSize)
		let previewData = image?.pngData()
		DispatchQueue.main.async { [self] in
			_ = StoredItem(context: context, data: data, previewData: previewData, type: .video, name: url.filename, fileExtension: url.pathExtension)
			completion(true)
		}
	}
	
	private func storeFile(at url: URL, completion: @escaping (Bool) -> Void) {
		guard let data = try? Data(contentsOf: url) else {
			return completion(false)
		}
		let request = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(side: previewSize), scale: 2, representationTypes: [.thumbnail])
		QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { [self] representation, _ in
			let previewData = representation?.uiImage.pngData()
			DispatchQueue.main.async {
				_ = StoredItem(context: context, data: data, previewData: previewData, type: .file, name: url.filename, fileExtension: url.pathExtension)
				completion(true)
			}
		}
	}
	
	private func storeRemoteUrl(_ url: URL, completion: @escaping (Bool) -> Void) {
		DispatchQueue.main.async {
			let provider = LPMetadataProvider()
			provider.startFetchingMetadata(for: url) { [self] metadata, error in
				func createItem(name: String? = nil, preview: Data? = nil) {
					DispatchQueue.main.async {
						_ = StoredItem(context: context, url: url, previewData: preview, name: name ?? url.absoluteString)
						completion(true)
					}
				}
				guard let metadata = metadata else { return createItem() }
				let name = metadata.title
				guard let imageProvider = metadata.imageProvider else { return createItem(name: name) }
				imageProvider.loadObject(ofClass: UIImage.self) { image, error in
					guard let image = image as? UIImage, let previewData = image.square(previewSize)?.jpegData(compressionQuality: 0.85) else {
						print(error?.localizedDescription ?? "Unknown error")
						return createItem(name: name)
					}
					createItem(name: name, preview: previewData)
				}
			}
		}
	}
}
