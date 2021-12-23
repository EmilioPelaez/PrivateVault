//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct GalleryView: View {
	
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var persistenceController: PersistenceManager
	@EnvironmentObject var settings: UserSettings
	@EnvironmentObject var diskStore: DiskStore
	@EnvironmentObject var filter: ItemFilter
	@State var dragOver = false
	@State var showLayoutMenu = false
	@State var showImageActionSheet = false
	@State var showPermissionAlert = false
	@State var showTags = false
	@State var showProcessing = false
	@State var multipleSelection = false
	@State var selectedItems: Set<StoredItem> = []
	@State var currentSheet: SheetItem?
	@State var currentAlert: AlertItem?
	@State var previewSelection: PreviewSelection?
	@State var itemBeingDeleted: StoredItem?
	@State var currentFolder: Folder?
	@Binding var isLocked: Bool
	
	@FetchRequest(sortDescriptors: [], animation: .default)
	var tags: FetchedResults<Tag>
	
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				GalleryHeaderView(text: $filter.searchText, placeholder: "Search...")
				Color(.secondarySystemBackground)
					.frame(height: 1)
				GalleryGridView(multipleSelection: $multipleSelection,
				                selectedItems: $selectedItems,
				                folder: currentFolder,
				                selection: select,
				                contextMenu: contextMenu,
				                folderContextMenu: folderContextMenu)
					.id(currentFolder?.identifier ?? "Home Folder")
					.transition(.opacity)
			}
			.fullScreenCover(item: $previewSelection, content: quickLookView)
			Group {
				if multipleSelection {
					selectionButtons
						.transition(.move(edge: .leading))
				} else {
					actionButtons
						.transition(.move(edge: .leading))
				}
			}
			.sheet(item: $currentSheet, content: sheetFor)
			processingView
		}
		.navigationTitle("Capsule")
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
			previewSelection = nil
			itemBeingDeleted = nil
		}
		.onChange(of: currentSheet) { newValue in
			if newValue == nil, !appState.attemptedToShowReviewPrompt {
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					ReviewPromptManager()?.trigger()
				}
				appState.attemptedToShowReviewPrompt = true
			}
		}
		.onChange(of: persistenceController.errorString) {
			$0.map { currentAlert = .persistenceError($0) }
		}
		.onChange(of: persistenceController.creatingFiles) { creating in
			guard !creating, !persistenceController.importErrors.isEmpty else { return }
			currentAlert = .importErrors(persistenceController.importErrors)
			persistenceController.flushErrors()
		}
		.onChange(of: appState.currentFolder) { folder in
			withAnimation {
				currentFolder = folder
			}
		}
		.onAppear {
			persistenceController.fatalErrorString.map { currentAlert = .persistenceFatalError($0) }
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
			.environmentObject(DiskStore())
	}
}
