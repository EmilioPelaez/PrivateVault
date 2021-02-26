//
//  PersistenceController+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import AVFoundation
import Photos
import QuickLook
import UIKit
import VisionKit

extension PersistenceController {
	
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
		if type.conforms(to: .image) {
			storeImage(at: url, completion: completion)
		} else if type.conforms(to: .video) || type.conforms(to: .movie) {
			storeVideo(at: url, completion: completion)
		} else {
			storeFile(at: url, completion: completion)
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
}
