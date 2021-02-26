//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct GalleryView: View {
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
		
		var id: Int {
			switch self {
			case .showPermissionAlert:
				return 0
			case .deleteItemConfirmation:
				return 1
			}
		}
	}
	
	@EnvironmentObject var persistenceController: PersistenceController
	@EnvironmentObject var settings: UserSettings
	@ObservedObject var filter = ItemFilter()
	@State var dragOver = false
	@State var showLayoutMenu = false
	@State var showImageActionSheet = false
	@State var showPermissionAlert = false
	@State var showTags = false
	@State var showProcessing = false
	@State var currentSheet: SheetItem?
	@State var currentAlert: AlertItem?
	@State var selectedItem: StoredItem?
	@State var itemBeingDeleted: StoredItem?
	@State var selectedTags: Set<Tag> = []
	@Binding var isLocked: Bool
	
	var body: some View {
		ZStack {
			GalleryGridView(selectedTags: $selectedTags, selection: select) {
				currentAlert = .deleteItemConfirmation($0)
			}
			.onDrop(of: [.fileURL], delegate: self)
			.fullScreenCover(item: $selectedItem, content: quickLookView)
			.navigationTitle("Gallery")
			.toolbar {
				leadingButtons
				trailingButton
			}
			actionButtons
			processingView
		}
		.alert(item: $currentAlert, content: alert)
		.onChange(of: isLocked) {
			guard $0 else { return }
			showImageActionSheet = false
			showPermissionAlert = false
			currentSheet = nil
			selectedItem = nil
			itemBeingDeleted = nil
		}
	}
}

struct GalleryView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		GalleryView(isLocked: .constant(false))
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.environmentObject(UserSettings())
	}
}
