//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import Photos
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
	
	@EnvironmentObject private var persistenceController: PersistenceController
	@EnvironmentObject private var settings: UserSettings
	@ObservedObject private var filter = ItemFilter()
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
			ZStack(alignment: .bottomLeading) {
				Color.clear
				if showTags {
					Color(white: 0, opacity: 0.001)
						.onTapGesture {
							withAnimation {
								showTags = false
							}
						}
				}
				HStack(alignment: .bottom) {
					FileTypePickerView(action: selectType)
						.sheet(item: $currentSheet, content: filePicker)
					VStack(alignment: .leading) {
						if showTags {
							FiltersView(filter: filter) {
								withAnimation {
									showTags = false
									currentSheet = .tags
								}
							}
							.transition(.scale(scale: 0, anchor: .bottomLeading))
						}
						Button {
							withAnimation {
								showTags.toggle()
							}
						}
						label: {
							ZStack {
								Circle()
									.fill(Color.green)
									.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
								Group {
									if showTags {
										Image(systemName: "tag.fill")
									} else {
										Image(systemName: "tag")
									}
								}
								.font(.system(size: 30))
								.foregroundColor(.white)
								.transition(.opacity)
							}
							.frame(width: 60, height: 60)
						}
					}
				}
				.padding(.horizontal)
				.padding(.bottom, 10)
			}
			ZStack(alignment: .bottom) {
				Color.clear
				if showProcessing {
					ImportProcessView()
						.transition(.opacity.combined(with: .move(edge: .bottom)))
				}
			}
			.padding()
			.onChange(of: persistenceController.creatingFiles) { creating in
				withAnimation { showProcessing = creating }
			}
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
	
	var leadingButtons: some ToolbarContent {
		ToolbarItemGroup(placement: .navigationBarLeading) {
			Button {
				currentSheet = .settings
			} label: {
				Image(systemName: "gearshape.fill")
			}
			Button {
				withAnimation { isLocked = true }
			} label: {
				Image(systemName: "lock.fill")
			}
		}
	}
	
	var trailingButton: some ToolbarContent {
		ToolbarItemGroup(placement: .navigationBarTrailing) {
			Menu {
				Button {
					withAnimation { settings.showDetails.toggle() }
				}
				label: {
					if settings.showDetails {
						Text("Hide File Details")
					} else {
						Text("Show File Details")
					}
					Image(systemName: "info.circle")
				}
				Menu {
					ForEach(1..<6) { columns in
						Button {
							withAnimation { settings.columns = columns }
						}
						label: {
							if columns == 1 {
								Text("\(columns) Column")
							} else {
								Text("\(columns) Columns")
							}
							Image(systemName: "\(columns).circle")
						}
					}
				} label: {
					Text("Columns")
					Image(systemName: "rectangle.split.3x1")
				}
			} label: {
				Image(systemName: "slider.horizontal.3")
			}
		}
	}
	
	func alert(currentAlert: AlertItem) -> Alert {
		switch currentAlert {
		case .showPermissionAlert:
			return Alert(
				title: Text("Camera Access"),
				message: Text("PrivateVault doesn't have access to use your camera, please update your privacy settings."),
				primaryButton: .default(
					Text("Settings"),
					action: {
						URL(string: UIApplication.openSettingsURLString).map { UIApplication.shared.open($0) }
					}
				),
				secondaryButton: .cancel()
			)
		case let .deleteItemConfirmation(item):
			return Alert(
				title: Text("Delete File"),
				message: Text("Are you sure you want to delete this item? This action can't be undone."),
				primaryButton: .destructive(Text("Delete"), action: { delete(item) }),
				secondaryButton: .cancel()
			)
		}
	}
	
	func select(_ item: StoredItem) {
		selectedItem = item
	}
	
	func delete(_ item: StoredItem) {
		persistenceController.delete(item)
	}
	
	func quickLookView(_ item: StoredItem) -> some View {
		QuickLookView(title: item.name, url: item.url).ignoresSafeArea()
	}
	
	func filePicker(_ item: SheetItem) -> some View {
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
	
	func selectType(_ type: FileTypePickerView.FileType) {
		switch type {
		case .camera: requestCameraAuthorization()
		case .album: requestImageAuthorization()
		case .document: currentSheet = .documentPicker
		case .scan: currentSheet = .documentScanner
		}
	}
	
	func requestImageAuthorization() {
		if PHPhotoLibrary.authorizationStatus() == .authorized {
			currentSheet = .imagePicker
		} else {
			PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
		}
	}
	
	func requestCameraAuthorization() {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized: currentSheet = .cameraPicker
		case .notDetermined: AVCaptureDevice.requestAccess(for: .video) { _ in }
		default: showPermissionAlert = true
		}
	}
}

extension GalleryView: DropDelegate {
	func dropEntered(info: DropInfo) { dragOver = true }
	
	func dropExited(info: DropInfo) { dragOver = false }
	
	func performDrop(info: DropInfo) -> Bool {
		persistenceController.receiveItems(info.itemProviders(for: [.image, .video, .movie, .pdf]))
		return true
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
