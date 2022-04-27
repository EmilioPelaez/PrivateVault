//
//  PhotosPicker.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import PhotosUI
import SwiftUI

struct PhotosPicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	
	var selectedMedia: ([NSItemProvider]) -> Void

	func makeUIViewController(context: UIViewControllerRepresentableContext<PhotosPicker>) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 0
		configuration.filter = .any(of: [.images, .videos /* , .livePhotos */ ])
		let imagePicker = PHPickerViewController(configuration: configuration)
		imagePicker.delegate = context.coordinator
		return imagePicker
	}

	func updateUIViewController(_: PHPickerViewController, context _: UIViewControllerRepresentableContext<PhotosPicker>) {}

	func makeCoordinator() -> Coordinator { Coordinator(self) }

	class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
		var parent: PhotosPicker

		init(_ parent: PhotosPicker) {
			self.parent = parent
		}

		func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			parent.selectedMedia(results.map(\.itemProvider))
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}

public extension View {
	func mediaImporter(isPresented: Binding<Bool>, didSelect: @escaping ([NSItemProvider]) -> Void) -> some View {
		sheet(isPresented: isPresented) {
			PhotosPicker(selectedMedia: didSelect)
				.ignoresSafeArea()
		}
	}
}
