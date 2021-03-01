//
//  GalleryView+Enums.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 1/3/21.
//

import Foundation

extension GalleryView {
	enum SheetItem: Int, Identifiable {
		case tags
		case settings
		case imagePicker
		case cameraPicker
		case documentPicker
		case documentScanner
		
		var id: Int { rawValue }
	}
	
	enum AlertItem: Identifiable {
		case showPermissionAlert
		case deleteItemConfirmation(StoredItem)
		case deleteItemsConfirmation(Set<StoredItem>)
		
		var id: Int {
			switch self {
			case .showPermissionAlert: return 0
			case .deleteItemConfirmation: return 1
			case .deleteItemsConfirmation: return 2
			}
		}
	}
}
