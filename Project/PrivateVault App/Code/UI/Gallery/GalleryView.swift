//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

enum GalleryViewSheetItem: Identifiable {
	case imagePicker
	case documentPicker
	case audioRecorder
	case quickLook(item: Item)
	
	var id: Int {
		switch self {
		case .imagePicker:
			return 1
		case .documentPicker:
			return 2
		case .audioRecorder:
			return 3
		case .quickLook:
			return 4
		}
	}
}

struct GalleryView: View {
	@State var contentMode: ContentMode = .fill //	Should this and showDetails be environment values?
	@State var showDetails: Bool = false
	@State var sheetState: GalleryViewSheetItem?
	@State var data: [Item] = .examples
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(data: $data, contentMode: $contentMode, showDetails: $showDetails) { sheetState = .quickLook(item: $0) }
				.padding(4)
				.navigationTitle("Gallery")
				.fullScreenCover(item: $sheetState) {
					switch $0 {
					case .imagePicker:
						ImagePicker(selectImage: selectImage)
					case .documentPicker:
						DocumentPicker(selectDocuments: selectDocuments)
					case .audioRecorder:
						AudioRecorder(recordAudio: recordAudio)
					case let .quickLook(item):
						quickLookView(item)
					}
				}
			FileTypePickerView() { fileType in
				switch fileType {
				case .photo:
					sheetState = .imagePicker
				case .audio:
					sheetState = .audioRecorder
				case .document:
					sheetState = .documentPicker
				}
			}
			.padding()
		}
	}
	
	func quickLookView(_ item: Item) -> some View {
		return QuickLookView(title: item.id.description, url: item.url)
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
