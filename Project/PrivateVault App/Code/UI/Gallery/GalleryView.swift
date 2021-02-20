//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import Photos
import SwiftUI

struct GalleryView: View {
	
	enum AddSheetItem: Int, Identifiable {
		case imagePicker
		case documentPicker
		case audioRecorder
		
		var id: Int { rawValue }
	}
	
	@Environment(\.managedObjectContext) private var viewContext
	
	@State var contentMode: ContentMode = .fill //	Should this and showDetails be environment values?
	@State var showDetails: Bool = true
	@State var addSheet: AddSheetItem?
	@State var selectedItem: StoredItem?
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(contentMode: $contentMode, showDetails: $showDetails, emptyView: EmptyGalleryView(), selection: select, delete: delete)
				.navigationTitle("Gallery")
				.fullScreenCover(item: $selectedItem, content: quickLookView)
			FileTypePickerView(action: selectType)
				.padding(.horizontal)
				.padding(.bottom, 5)
				.sheet(item: $addSheet, content: filePicker)
		}
	}
	
	func select(_ item: StoredItem) {
		selectedItem = item
	}
	
	func delete(_ item: StoredItem) {
		viewContext.delete(item)
		saveContext()
	}
	
	func quickLookView(_ item: StoredItem) -> some View {
		QuickLookView(title: item.name, url: item.url).ignoresSafeArea()
	}
	
	func filePicker(_ item: AddSheetItem) -> some View {
		Group {
			switch item {
			case .imagePicker: ImagePicker(closeSheet: { addSheet = nil }, selectImage: selectImage)
			case .documentPicker: DocumentPicker(selectDocuments: selectDocuments)
			case .audioRecorder: AudioRecorder(recordAudio: recordAudio)
			}
		}
	}
	
	func selectType(_ type: FileTypePickerView.FileType) {
		switch type {
		case .photo: requestImageAuthorization()
		case .audio: addSheet = .audioRecorder
		case .document: addSheet = .documentPicker
		}
	}
	
	func requestImageAuthorization() {
		if PHPhotoLibrary.authorizationStatus() == .authorized {
			addSheet = .imagePicker
		} else {
			PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
		}
	}
	
	func selectImage(_ image: UIImage, filename: String) {
		_ = StoredItem(context: viewContext, image: image, filename: filename)
		saveContext()
	}
	
	func selectDocuments(_ documentURLs: [URL]) {
		print(documentURLs)
	}
	
	func recordAudio(_ audioURL: URL) {
		fatalError("Audio recording is not implemented yet.")
	}
	
	private func saveContext() {
		do {
			try viewContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView()
	}
}

struct AudioRecorder: View {
	var recordAudio: (URL) -> Void
	
	var body: some View {
		EmptyView()
	}
}
