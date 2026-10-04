//
//  ImagePicker.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import Middleware
import Persistence
import SwiftUI

public struct CameraPicker: UIViewControllerRepresentable {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) private var presentationMode
	
	var selectImage: (UIImage, Folder?) -> Void
	
	public init(selectImage: @escaping (UIImage, Folder?) -> Void) {
		self.selectImage = selectImage
	}
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
		let cameraPicker = UIImagePickerController()
		cameraPicker.allowsEditing = false
		cameraPicker.sourceType = .camera
		cameraPicker.delegate = context.coordinator
		return cameraPicker
	}

	public func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<CameraPicker>) {}

	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var parent: CameraPicker

		init(_ parent: CameraPicker) {
			self.parent = parent
		}

		public func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
			if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
				parent.selectImage(image.fixOrientation(), parent.appState.currentFolder)
			}
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
