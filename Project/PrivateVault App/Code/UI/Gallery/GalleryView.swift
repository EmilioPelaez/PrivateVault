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

	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.persistenceController) private var persistenceController
	@State var dragOver = false
	@State var showImageActionSheet = false
	@State var showPermissionAlert = false
	@State var currentSheet: SheetItem?
	@State var currentAlert: AlertItem?
	@State var selectedItem: StoredItem?
	@State var itemBeingDeleted: StoredItem?
	@State var selectedTags: Set<Tag> = []
	@Binding var isLocked: Bool

	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(
				selectedTags: $selectedTags,
				selection: select,
				delete: { currentAlert = .deleteItemConfirmation($0) }
			)
				.onDrop(of: [.fileURL], delegate: self)
				.fullScreenCover(item: $selectedItem, content: quickLookView)
				.navigationTitle("Gallery")
				.toolbar(content: {
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
				})
			FileTypePickerView(action: selectType)
				.sheet(item: $currentSheet, content: filePicker)
				.padding(.horizontal)
				.padding(.bottom, 10)
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
					action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }
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
			case .cameraPicker: CameraPicker(selectImage: { selectItem(.capture($0)) })
			case .documentPicker: DocumentPicker(selectDocuments: { selectItems($0.map({ .file($0) })) })
			case .documentScanner: DocumentScanner(selectScan: { selectItem(.capture($0)) })
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

	func selectItems(_ items: [ItemType]) {
		items.forEach(selectItem)
	}

	func selectItem(_ item: ItemType) {
		_ = StoredItem(context: viewContext, item: item)
		persistenceController?.saveContext()
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
		loadData(from: info.itemProviders(for: [.jpeg, .png]))
		return true
	}
}

enum ItemType {
	case photo(UIImage, String)
	case capture(UIImage)
	case file(URL)
}

extension GalleryView {
	func loadData(from itemProviders: [NSItemProvider]) {
		itemProviders.forEach(loadData)
	}

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
						selectItem(.photo(image.fixOrientation(), url.lastPathComponent))
						//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: image))
					}
				} else {
					if let livePhoto = object as? PHLivePhoto {
						print(livePhoto)
						//self.parent.selectImage(livePhoto, "filename")
						//self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: livePhoto))
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

			selectItem(.file(targetURL))
		} catch {
			print(error.localizedDescription)
		}
	}
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView(isLocked: .constant(false))
	}
}
