//
//  GalleryView+Enums.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 1/3/21.
//

import Foundation

extension GalleryView {
	enum SheetItem: Identifiable {
		case tags
		case settings
		case imagePicker
		case cameraPicker
		case documentPicker
		case documentScanner
		case share([URL])
		case itemEdit(StoredItem)
		
		var id: Int {
			switch self {
			case .tags: return 0
			case .settings: return 1
			case .imagePicker: return 2
			case .cameraPicker: return 3
			case .documentPicker: return 4
			case .documentScanner: return 5
			case .share: return 6
			case .itemEdit: return 7
			}
		}
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
