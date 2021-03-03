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
				diskStore.add(item) {
					switch $0 {
					case .success(let diskItem):
						displayedItem = diskItem
					case .failure(let error): print(error)
					}
				}
			}
		}
	}
	
	func delete(_ item: StoredItem) {
		delete([item])
	}
	
	func delete(_ items: Set<StoredItem>) {
		persistenceController.delete(items.map { $0 })
		withAnimation {
			multipleSelection = false
			selectedItems = []
		}
	}
	
	func quickLookView(_ item: DiskStore.Item) -> some View {
		QuickLookView(store: diskStore, item: item).ignoresSafeArea()
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
