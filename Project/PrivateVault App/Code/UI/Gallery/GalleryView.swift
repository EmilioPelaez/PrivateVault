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
	@State var contentMode: ContentMode = .fill
	@State var sheetState: GalleryViewSheetItem?
	@State var data: [Item] = (1...6)
		.map { "file\($0)" }
		.map { Image($0) }
		.map(Item.init)
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GalleryGridView(data: $data, contentMode: $contentMode) { sheetState = .quickLook(item: $0) }
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
		let data = try! Data(contentsOf: URL(string: "https://img.ibxk.com.br/2020/08/07/07115418185111.jpg")!)
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let imagePath = paths[0].appendingPathComponent("caramelo.jpg")
		FileManager.default.createFile(atPath: imagePath.path, contents: data)
		return QuickLookView(title: item.id.description, url: URL(fileURLWithPath: imagePath.path))
	}
	
	func selectImage(_ image: UIImage) {
		data.append(Item(image: Image(uiImage: image)))
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
