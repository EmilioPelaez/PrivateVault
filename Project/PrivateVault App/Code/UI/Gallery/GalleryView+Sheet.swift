//
//  GalleryView+Sheet.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import SwiftUI

extension GalleryView {
	func sheetFor(_ item: SheetItem) -> some View {
		Group {
			switch item {
			case .tags: ManageTagsView(selectedTags: $selectedTags)
			case .imagePicker: PhotosPicker(selectedMedia: persistenceController.receiveItems)
			case .cameraPicker: CameraPicker(selectImage: persistenceController.receiveCapturedImage)
			case .documentPicker: DocumentPicker(selectDocuments: persistenceController.receiveURLs)
			case .documentScanner: DocumentScanner(didScan: persistenceController.receiveScan)
			case .settings: SettingsView()
			}
		}
		.ignoresSafeArea()
	}
}
