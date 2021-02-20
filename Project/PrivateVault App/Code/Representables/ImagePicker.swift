//
//  ImagePicker.swift
//  SwiftUIImagePicker
//
//  Created by Simon Ng on 10/6/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) private var presentationMode
	var closeSheet: () -> Void
	var selectImage: (UIImage) -> Void

	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 0
		configuration.filter = .any(of: [.images, .livePhotos, .videos])
		let imagePicker = PHPickerViewController(configuration: configuration)
		imagePicker.delegate = context.coordinator
		return imagePicker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	final class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
		var parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}

		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			for image in results {
				if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
					image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
						if let error = error {
							print("Can't load image \(error.localizedDescription)")
						} else if let image = newImage as? UIImage {
							self?.parent.selectImage(image)
						}
					}
				} else {
					print("Can't load asset")
				}
			}
			parent.closeSheet()
		}
	}
}
