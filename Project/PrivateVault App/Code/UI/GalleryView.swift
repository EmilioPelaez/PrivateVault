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
	@State var isShowingActionSheet = false
	@State var contentMode: ContentMode = .fill
	@State var sheetState: GalleryViewSheetItem?
	@State var data: [Item] = (1...6)
		.map { "file\($0)" }
		.map { Image($0) }
		.map(Item.init)
	
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	var body: some View {
		ZStack {
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(data) { item in
						Color.red.aspectRatio(1, contentMode: .fill)
							.overlay(
								item.image
									.resizable()
									.aspectRatio(contentMode: contentMode)
							)
							.clipped()
							.onTapGesture { sheetState = .quickLook(item: item) }
					}
				}
			}
			.navigationTitle("Gallery")
			.fullScreenCover(item: $sheetState) {
				switch $0 {
				case .imagePicker:
					ImagePicker(selectImage: selectImage)
				case .documentPicker:
					DocumentPicker(selectDocument: selectDocument)
				case .audioRecorder:
					AudioRecorder(recordAudio: recordAudio)
				case let .quickLook(item):
					quickLookView(item)
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						withAnimation(Animation.interpolatingSpring(stiffness: 70, damping: 10.0)) {
							isShowingActionSheet = true
						}
						//sheetState = .imagePicker
					} label: {
						Image(systemName: "plus")
					}
					
				}
			}
			VStack {
				Spacer()
				ZStack {
					RoundedRectangle(cornerRadius: 25.0)
						.foregroundColor(.white)
						.shadow(radius: 25)
					FileTypePickerView() { fileType in
						switch fileType {
						case .photo:
							sheetState = .imagePicker
						case .audio:
							sheetState = .audioRecorder
						case .document:
							sheetState = .documentPicker
						}					}
						.padding()
				}
				.frame(width: 300, height: 100, alignment: .center)
				.offset(y: isShowingActionSheet ? 0 : 200)
			}
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
	
	func selectDocument(_ documentURL: URL) {
		fatalError("Document selection is not implemented yet.")
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

struct DocumentPicker: View {
	var selectDocument: (URL) -> Void
	
	var body: some View {
		EmptyView()
	}
}

struct AudioRecorder: View {
	var recordAudio: (URL) -> Void
	
	var body: some View {
		EmptyView()
	}
}
