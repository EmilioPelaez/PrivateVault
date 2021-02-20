//
//  ImagePicker.swift
//  SwiftUIImagePicker
//
//  Created by Simon Ng on 10/6/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) private var presentationMode
	var selectImage: (UIImage) -> ()
	var sourceType: UIImagePickerController.SourceType = .photoLibrary

	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = false
		imagePicker.sourceType = sourceType
		imagePicker.delegate = context.coordinator
		return imagePicker
	}

	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}

		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
				parent.selectImage(image)
			}

			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
