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
	@Binding var isLocked: Bool
	
	@FetchRequest(sortDescriptors: [], animation: .default)
	var tags: FetchedResults<Tag>
	
	var body: some View {
		ZStack {
			GalleryGridView(filter: filter, selection: select) {
				currentAlert = .deleteItemConfirmation($0)
			}
			.fullScreenCover(item: $selectedItem, content: quickLookView)
			actionButtons
			processingView
		}
		.navigationTitle("Gallery")
		.toolbar {
			leadingButtons
			trailingButton
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
		.onDrop(of: [.fileURL], delegate: self)
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
