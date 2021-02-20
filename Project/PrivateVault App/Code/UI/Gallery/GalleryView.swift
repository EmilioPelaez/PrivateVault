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
	
	@State var contentMode: ContentMode = .fill //	Should this and showDetails be environment values?
	@State var showDetails: Bool = true
	@State var addSheet: AddSheetItem?
	@State var selectedItem: Item?
	@State var data: [Item] = []
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(data: $data, contentMode: $contentMode, showDetails: $showDetails, emptyView: emptyView) { selectedItem = $0 }
				.navigationTitle("Gallery")
				.fullScreenCover(item: $selectedItem, content: quickLookView)
			FileTypePickerView(action: selectType)
			.padding(.horizontal)
			.padding(.bottom, 5)
			.sheet(item: $addSheet, content: filePicker)
		}
	}

	var emptyView: some View {
		VStack(spacing: 10) {
			Image(systemName: "face.smiling.fill")
				.font(.largeTitle)
			Text("Your gallery is empty!")
			Text("Add some documents to get started :)")
		}
		.font(.headline)
	}
	
	func quickLookView(_ item: Item) -> some View {
		QuickLookView(title: item.title, url: item.url).ignoresSafeArea()
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
		case .photo:
			requestImageAuthorization()
		case .audio: addSheet = .audioRecorder
		case .document: addSheet = .documentPicker
		}
	}

	func requestImageAuthorization() {
		PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
			switch status {
			case .notDetermined:
			// The user hasn't determined this app's access.
			break
			case .restricted:
			// The system restricted this app's access.
			break
			case .denied:
			// The user explicitly denied this app's access.
			break
			case .authorized:
			// The user authorized this app to access Photos data.
			addSheet = .imagePicker
			case .limited:
			// The user authorized this app for limited Photos access.
			break
			@unknown default:
				fatalError()
			}
		}
	}
	
	func selectImage(_ image: UIImage) {
		data.append(Item(image: image))
	}
	
	func selectDocuments(_ documentURLs: [URL]) {
		print(documentURLs)
	}
	
	func recordAudio(_ audioURL: URL) {
		fatalError("Audio recording is not implemented yet.")
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
