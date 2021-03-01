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
		withAnimation {
			if multipleSelection {
				if selectedItems.contains(item) {
					selectedItems.remove(item)
				} else {
					selectedItems.insert(item)
				}
			} else {
				displayedItem = item
			}
		}
	}
	
	func delete(_ item: StoredItem) {
		persistenceController.delete(item)
	}
	
	func delete(_ items: Set<StoredItem>) {
		persistenceController.delete(items.map { $0 })
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
