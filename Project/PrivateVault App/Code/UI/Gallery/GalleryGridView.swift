//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView<M: View, N: View>: View {
	
	@EnvironmentObject private var appState: AppState
	@EnvironmentObject private var settings: UserSettings
	@EnvironmentObject var filter: ItemFilter
	@Binding var multipleSelection: Bool
	@Binding var selectedItems: Set<StoredItem>
	
	let selection: (StoredItem, [StoredItem]) -> Void
	let contextMenu: (StoredItem) -> M
	let folderContextMenu: (Folder) -> N
	
	private var itemsFetchRequest: FetchRequest<StoredItem>
	private var foldersFetchRequest: FetchRequest<Folder>
	
	private let folder: Folder?
	
	private var items: FetchedResults<StoredItem> {
		itemsFetchRequest.wrappedValue
	}
	
	private var folders: FetchedResults<Folder> {
		foldersFetchRequest.wrappedValue
	}

	var sortedFolders: [Folder] {
		folders.sorted(by: settings.sort.apply)
	}
	
	var filteredItems: [StoredItem] {
		items.filter(filter.apply).sorted(by: settings.sort.apply)
	}
	
	init(multipleSelection: Binding<Bool>, selectedItems: Binding<Set<StoredItem>>, folder: Folder?, selection: @escaping (StoredItem, [StoredItem]) -> Void, contextMenu: @escaping (StoredItem) -> M, folderContextMenu: @escaping (Folder) -> N) {
		self._multipleSelection = multipleSelection
		self._selectedItems = selectedItems
		self.selection = selection
		self.contextMenu = contextMenu
		self.folderContextMenu = folderContextMenu
		let itemsPredicate = NSPredicate(format: "folder == %@", folder ?? NSNull())
		let folderPredicate = NSPredicate(format: "parent == %@", folder ?? NSNull())
		itemsFetchRequest = FetchRequest<StoredItem>(entity: StoredItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StoredItem.timestamp, ascending: false)], predicate: itemsPredicate)
		foldersFetchRequest = FetchRequest<Folder>(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: false)], predicate: folderPredicate)
		self.folder = folder
	}

	var body: some View {
		if items.isEmpty && folders.isEmpty && folder != nil {
			ZStack {
				Color.clear
				EmptyFolderView()
					.frame(maxWidth: 280)
					.transition(.opacity)
			}
		} else if items.isEmpty && folders.isEmpty {
			ZStack {
				Color.clear
				EmptyGalleryView()
					.frame(maxWidth: 280)
					.transition(.opacity)
			}
		} else if filteredItems.isEmpty && folders.isEmpty {
			ZStack {
				Color.clear
				FilteredGalleryView {
					withAnimation { filter.clear() }
				}
				.frame(maxWidth: 280)
				.transition(.opacity)
			}
		} else {
			ScrollView {
				VStack(spacing: 4) {
					LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 4)], spacing: 4) {
						ForEach(sortedFolders) { folder in
							GalleryGridFolderCell(folder: folder, style: items.isEmpty ? .folder : .compact)
								.onTapGesture {
									appState.currentFolder = folder
								}
								.contextMenu { folderContextMenu(folder) }
						}
					}
					LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: settings.columns), spacing: 4) {
						ForEach(filteredItems) { item in
							GalleryGridCell(item: item, selection: selection(for: item))
								.onTapGesture { selection(item, filteredItems) }
								.contextMenu { contextMenu(item) }
						}
					}
					.padding(.bottom, 69)
				}
				.padding(4)
			}
		}
	}
	
	func selection(for item: StoredItem) -> GalleryGridCell.Selection {
		guard multipleSelection else { return .disabled }
		return selectedItems.contains(item) ? .selected : .unselected
	}
}

struct GalleryGridView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()

	static var previews: some View {
		GalleryGridView(multipleSelection: .constant(false),
		                selectedItems: .constant([]),
		                folder: preview.folder,
		                selection: { _, _ in },
		                contextMenu: { _ in EmptyView() },
		                folderContextMenu: { _ in EmptyView() })
			.environment(\.managedObjectContext, preview.context)
			.environmentObject(preview.controller)
			.environmentObject(UserSettings())
	}
}
