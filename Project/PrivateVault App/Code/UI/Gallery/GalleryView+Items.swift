//
//  GalleryView+Items.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import Photos
import SwiftUI

extension GalleryView {
	func select(_ item: StoredItem) {
		selectedItem = item
	}
	
	func delete(_ item: StoredItem) {
		persistenceController.delete(item)
	}
	
	func quickLookView(_ item: StoredItem) -> some View {
		QuickLookView(title: item.name, url: item.url).ignoresSafeArea()
	}
	
	func selectType(_ type: FileTypePickerView.FileType) {
		switch type {
		case .camera: requestCameraAuthorization()
		case .album: currentSheet = .imagePicker
		case .document: currentSheet = .documentPicker
		case .scan: currentSheet = .documentScanner
		}
	}
	
	func requestCameraAuthorization() {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized: currentSheet = .cameraPicker
		case .notDetermined: AVCaptureDevice.requestAccess(for: .video) { _ in }
		default: showPermissionAlert = true
		}
	}
}
