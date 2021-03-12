//
//  GalleryView+Items.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import Photos
import SwiftUI
import UIKit

extension GalleryView {
	
	func contextMenu(for item: StoredItem) -> some View {
		Group {
			Button {
				currentSheet = .itemEdit(item)
			} label: {
				Text("Edit")
				Image(systemName: "square.and.pencil")
			}
			Button {
				share(item)
			} label: {
				Text("Share")
				Image(systemName: "square.and.arrow.up")
			}
			Divider()
			Button {
				currentAlert = .deleteItemConfirmation(item)
			} label: {
				Text("Delete")
				Image(systemName: "trash")
			}
		}
	}
	
	func select(_ item: StoredItem, list: [StoredItem]) {
		withAnimation {
			if multipleSelection {
				if selectedItems.contains(item) {
					selectedItems.remove(item)
				} else {
					selectedItems.insert(item)
				}
			} else {
				previewSelection = PreviewSelection(item: item, list: list)
			}
		}
	}
	
	func share(_ item: StoredItem) {
		if item.dataType != .url {
			diskStore.add(item) { result in
				switch result {
				case .success(let item):
					self.currentSheet = .share([item.url])
				case .failure: break
				}
			}
		} else if let url = item.remoteUrl {
			currentSheet = .share([url])
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
	
	func quickLookView(_ selection: PreviewSelection) -> some View {
		Group {
			switch selection {
			case let .url(url): SafariView(url: url)
			case let .quickLook(selection): QuickLookView(store: diskStore, selection: selection)
			}
		}
		.ignoresSafeArea()
	}
	
	func selectType(_ type: FileTypePickerView.FileType) {
		switch type {
		case .camera: requestCameraAuthorization()
		case .album: currentSheet = .imagePicker
		case .document: currentSheet = .documentPicker
		case .scan: currentSheet = .documentScanner
		case .clipboard: importFromClipboard()
		}
	}
	
	func requestCameraAuthorization() {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized: currentSheet = .cameraPicker
		case .notDetermined: AVCaptureDevice.requestAccess(for: .video) { _ in }
		default: showPermissionAlert = true
		}
	}
	
	func importFromClipboard() {
		let clipboard = UIPasteboard.general
		guard clipboard.numberOfItems > 0 else {
			currentAlert = .emptyClipboard
			return
		}
		persistenceController.receiveItems(clipboard.itemProviders)
	}
}
