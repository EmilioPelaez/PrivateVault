//
//  ImagePicker.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) private var presentationMode
	
	var selectedImage: (UIImage) -> Void

	func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
		let cameraPicker = UIImagePickerController()
		cameraPicker.allowsEditing = false
		cameraPicker.sourceType = .camera
		cameraPicker.delegate = context.coordinator
		return cameraPicker
	}

	func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<CameraPicker>) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var parent: CameraPicker

		init(_ parent: CameraPicker) {
			self.parent = parent
		}

		func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
			if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
				parent.selectedImage(image)
			}
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}

public extension View {
	func cameraImporter(isPresented: Binding<Bool>, didSelect: @escaping (UIImage) -> Void) -> some View {
		sheet(isPresented: isPresented) {
			CameraPicker(selectedImage: didSelect)
				.ignoresSafeArea()
		}
	}
}
