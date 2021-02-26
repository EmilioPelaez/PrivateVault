//
//  GalleryView+DropDelegate.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import SwiftUI

extension GalleryView: DropDelegate {
	func dropEntered(info: DropInfo) { dragOver = true }
	
	func dropExited(info: DropInfo) { dragOver = false }
	
	func performDrop(info: DropInfo) -> Bool {
		persistenceController.receiveItems(info.itemProviders(for: [.image, .video, .movie, .pdf]))
		return true
	}
}
