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
	
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.persistenceController) private var persistenceController
	
	@State var showPermissionAlert = false
	@State var currentSheet: SheetItem?
	@State var selectedItem: StoredItem?
	@State var selectedTags: Set<Tag> = []
	@Binding var isLocked: Bool
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(selectedTags: $selectedTags, selection: select, delete: delete)
				.fullScreenCover(item: $selectedItem, content: quickLookView)
				.navigationTitle("Gallery")
				.toolbar(content: {
					ToolbarItemGroup(placement: .navigationBarLeading) {
						Button(action: { currentSheet = .settings }) {
							Image(systemName: "gearshape.fill")
						}
						Button(action: { isLocked = true }) {
							Image(systemName: "lock.fill")
						}
					}
					ToolbarItemGroup(placement: .navigationBarTrailing) {
						
						Button(action: { currentSheet = .tags }) {
							Image(systemName: "tag.fill")
						}
					}
				})
			FileTypePickerView(action: selectType)
				.sheet(item: $currentSheet, content: filePicker)
				.padding(.horizontal)
				.padding(.bottom, 10)
		}
		.alert(isPresented: $showPermissionAlert) {
			Alert(
				title: Text("Camera Access"),
				message: Text("PrivateVault doesn't have access to use your camera, please update your privacy settings."),
				primaryButton: .default(
					Text("Settings"),
					action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }
				),
				secondaryButton: .cancel())
		}
	}
	
	func select(_ item: StoredItem) {
		selectedItem = item
	}
	
	func delete(_ item: StoredItem) {
		viewContext.delete(item)
		persistenceController?.saveContext()
	}
	
	func quickLookView(_ item: StoredItem) -> some View {
		QuickLookView(title: item.name, url: item.url).ignoresSafeArea()
	}
	
	func filePicker(_ item: SheetItem) -> some View {
		Group {
			switch item {
			case .tags: TagListView(selectedTags: $selectedTags) { currentSheet = nil }
			case .imagePicker: PhotosPicker(closeSheet: { currentSheet = nil }, selectImage: selectImage)
			case .cameraPicker: CameraPicker(selectImage: selectCameraCapture)
			case .documentPicker: DocumentPicker(selectDocuments: selectDocuments)
			case .documentScanner: DocumentScanner(selectScan: selectCameraCapture)
			case .settings: SettingsView { currentSheet = nil }
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
		case .authorized:
			currentSheet = .cameraPicker
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video) { _ in }
		default:
			showPermissionAlert = true
		}
	}
	
	func selectImage(_ image: UIImage, filename: String) {
		_ = StoredItem(context: viewContext, image: image, filename: filename)
		persistenceController?.saveContext()
	}
	
	func selectCameraCapture(_ image: UIImage) {
		_ = StoredItem(context: viewContext, image: image, filename: "New photo")
		persistenceController?.saveContext()
	}
	
	func selectDocuments(_ documentURLs: [URL]) {
		print(documentURLs)
	}
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView(isLocked: .constant(false))
	}
}
