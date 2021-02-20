//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

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
	@State var data: [Item] = .examples
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(data: $data, contentMode: $contentMode, showDetails: $showDetails) { selectedItem = $0 }
				.navigationTitle("Gallery")
				.fullScreenCover(item: $selectedItem, content: quickLookView)
			FileTypePickerView(action: selectType)
			.padding(.horizontal)
			.padding(.bottom, 5)
			.sheet(item: $addSheet, content: filePicker)
		}
	}
	
	func quickLookView(_ item: Item) -> some View {
		QuickLookView(title: item.title, url: item.url).ignoresSafeArea()
	}
	
	func filePicker(_ item: AddSheetItem) -> some View {
		Group {
			switch item {
			case .imagePicker: ImagePicker(selectImage: selectImage)
			case .documentPicker: DocumentPicker(selectDocuments: selectDocuments)
			case .audioRecorder: AudioRecorder(recordAudio: recordAudio)
			}
		}
	}
	
	func selectType(_ type: FileTypePickerView.FileType) {
		switch type {
		case .photo: addSheet = .imagePicker
		case .audio: addSheet = .audioRecorder
		case .document: addSheet = .documentPicker
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
