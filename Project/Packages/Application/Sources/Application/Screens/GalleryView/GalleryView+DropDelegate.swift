//
//  GalleryView+DropDelegate.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import SwiftUI

extension GalleryView: DropDelegate {
	func dropEntered(info _: DropInfo) { dragOver = true }
	
	func dropExited(info _: DropInfo) { dragOver = false }
	
	func performDrop(info: DropInfo) -> Bool {
		persistenceController.receiveItems(info.itemProviders(for: [.image, .video, .movie, .pdf]), folder: appState.currentFolder)
		return true
	}
}
