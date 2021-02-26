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
	@State var dragOver = false
	@State var showImageActionSheet = false
	@State var showPermissionAlert = false
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
				ToolbarItemGroup(placement: .navigationBarLeading) {
					Button {
						currentSheet = .settings
					} label: {
						Image(systemName: "gearshape.fill")
					}
					Button {
						withAnimation {
							isLocked = true
						}
					} label: {
						Image(systemName: "lock.fill")
					}
				}
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button {
						currentSheet = .tags
					} label: {
						Image(systemName: "tag.fill")
					}
				}
			}
			ZStack(alignment: .bottomLeading) {
				Color.clear
				FileTypePickerView(action: selectType)
					.sheet(item: $currentSheet, content: filePicker)
			}
			.padding(.horizontal)
			.padding(.bottom, 10)
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
			case .tags: TagListView(selectedTags: $selectedTags)
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
		persistenceController.receiveItems(info.itemProviders(for: [.image, .video, .pdf]))
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
