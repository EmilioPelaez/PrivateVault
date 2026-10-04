//
//  PhotosPicker.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import Middleware
import Persistence
import PhotosUI
import SwiftUI

public struct PhotosPicker: UIViewControllerRepresentable {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) var presentationMode
	
	var selectedMedia: ([NSItemProvider], Folder?) -> Void
	
	public init(selectedMedia: @escaping ([NSItemProvider], Folder?) -> Void) {
		self.selectedMedia = selectedMedia
	}
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<PhotosPicker>) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 0
		configuration.filter = .any(of: [.images, .videos /* , .livePhotos */ ])
		let imagePicker = PHPickerViewController(configuration: configuration)
		imagePicker.delegate = context.coordinator
		return imagePicker
	}

	public func updateUIViewController(_: PHPickerViewController, context _: UIViewControllerRepresentableContext<PhotosPicker>) {}

	public func makeCoordinator() -> Coordinator { Coordinator(self) }

	public class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
		var parent: PhotosPicker

		init(_ parent: PhotosPicker) {
			self.parent = parent
		}

		public func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			parent.selectedMedia(results.map(\.itemProvider), parent.appState.currentFolder)
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
