//
//  PhotosPicker.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import UIKit
import SwiftUI
import PhotosUI

struct PhotosPicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) private var presentationMode
	var closeSheet: () -> Void
	var selectImage: (UIImage, String) -> Void
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<PhotosPicker>) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 0
		configuration.filter = .any(of: [.images, .videos/*, .livePhotos*/])
		let imagePicker = PHPickerViewController(configuration: configuration)
		imagePicker.delegate = context.coordinator
		return imagePicker
	}
	
	func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PhotosPicker>) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	final class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
		var parent: PhotosPicker
		
		init(_ parent: PhotosPicker) {
			self.parent = parent
		}
		
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			parent.closeSheet()
			
			for result in results {
				let itemProvider = result.itemProvider
				
				guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
							let utType = UTType(typeIdentifier)
				else { continue }
				
				itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
					if let error = error {
						print(error.localizedDescription)
					}
					
					guard let url = url else {
						print("Failed to get url")
						return
					}
					
					if utType.conforms(to: .image) {
						self.getPhoto(from: itemProvider, url: url)
					} else if utType.conforms(to: .movie) {
						self.getVideo(from: url)
					} else {
						self.getPhoto(from: itemProvider, url: url, isLivePhoto: true)
					}
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
							DispatchQueue.main.async {
								self.parent.selectImage(image, url.lastPathComponent)
								//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: image))
							}
						}
					} else {
						if let livePhoto = object as? PHLivePhoto {
							DispatchQueue.main.async {
								print(livePhoto)
								//self.parent.selectImage(livePhoto, "filename")
								//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: livePhoto))
							}
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
				
				DispatchQueue.main.async {
					//self.parent.selectImage(targetURL, "filename")
					//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: targetURL))
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}
