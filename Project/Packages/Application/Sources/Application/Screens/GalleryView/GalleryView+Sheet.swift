//
//  GalleryView+Sheet.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import FolderEditor
import ImportScreens
import ItemEditor
import Settings
import SharedUI
import SwiftUI
import Tags

extension GalleryView {
	func sheetFor(_ item: SheetItem) -> some View {
		Group {
			switch item {
			case .tags: ManageTagsView(filter: filter)
			case .cameraPicker: CameraPicker(selectImage: persistenceController.receiveCapturedImage)
			case .documentScanner: DocumentScanner(didScan: persistenceController.receiveScan)
			case let .share(items): ShareSheet(items: items)
			case let .itemEdit(item): ItemEditView(item: item)
			case .settings: SettingsView()
			case .addNewFolder: NewFolderView()
			case let .editFolder(folder): EditFolderView(folder: folder)
			case let .folderSelection(item): FolderSelectionView(item: item)
			}
		}
		.ignoresSafeArea()
	}
}
