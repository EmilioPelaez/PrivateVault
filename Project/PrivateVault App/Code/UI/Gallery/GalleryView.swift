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
	@State var dragOver = false
	@State var showImageActionSheet = false
	@State var showPermissionAlert = false
	@State var currentSheet: SheetItem?
	@State var selectedItem: StoredItem?
	@State var selectedTags: Set<Tag> = []
	@Binding var isLocked: Bool
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(selectedTags: $selectedTags, selection: select, delete: delete)
				.onDrop(of: [.fileURL], delegate: self)
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
			case .imagePicker: PhotosPicker(closeSheet: { currentSheet = nil }, loadData: loadData)
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
		for documentURL in documentURLs {
			_ = StoredItem(context: viewContext, url: documentURL)
			persistenceController?.saveContext()
		}
	}
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView(isLocked: .constant(false))
	}
}

extension GalleryView: DropDelegate {
	func dropEntered(info: DropInfo) {
		dragOver = true
	}

	func dropExited(info: DropInfo) {
		dragOver = false
	}

	func performDrop(info: DropInfo) -> Bool {
		info.itemProviders(for: [.jpeg, .png]).forEach(loadData)
		return true
	}
}

extension GalleryView {
	func loadData(from itemProvider: NSItemProvider) {
		guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
			  let utType = UTType(typeIdentifier)
		else { return }

		itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
			if let error = error {
				print(error.localizedDescription)
			}

			guard let url = url else {
				print("Failed to get url")
				return
			}

			if utType.conforms(to: .image) {
				getPhoto(from: itemProvider, url: url)
			} else if utType.conforms(to: .movie) {
				getVideo(from: url)
			} else if utType.conforms(to: .livePhoto) {
				getPhoto(from: itemProvider, url: url, isLivePhoto: true)
			}
		}
	}

	private func getPhoto(from itemProvider: NSItemProvider, url: URL, isLivePhoto: Bool = false) {
		let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self

		if itemProvider.canLoadObject(ofClass: objectType) {
			itemProvider.loadObject(ofClass: objectType) { object, error in
				if let error = error {
					print(error.localizedDescription)
				}

				if !isLivePhoto {
					if let image = object as? UIImage {
						DispatchQueue.main.async {
							self.selectImage(image, filename: url.lastPathComponent)
							//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: image))
						}
					}
				} else {
					if let livePhoto = object as? PHLivePhoto {
						DispatchQueue.main.async {
							print(livePhoto)
							//self.parent.selectImage(livePhoto, "filename")
							//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: livePhoto))
						}
					}
				}
			}
		}
	}


	private func getVideo(from url: URL) {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }

		do {
			if FileManager.default.fileExists(atPath: targetURL.path) {
				try FileManager.default.removeItem(at: targetURL)
			}

			try FileManager.default.copyItem(at: url, to: targetURL)

			DispatchQueue.main.async {
				//self.parent.selectImage(targetURL, "filename")
				//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: targetURL))
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
