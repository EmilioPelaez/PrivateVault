//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

enum GalleryViewSheetItem: Identifiable {
	case imagePicker
	case quickLook(item: Item)

	var id: Int {
		switch self {
		case .imagePicker:
			return 1
		case .quickLook:
			return 2
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

	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	var body: some View {
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
		.fullScreenCover(item: $sheetState) {
			switch $0 {
			case .imagePicker:
				ImagePicker(selectImage: selectImage)
			case let .quickLook(item):
				quickLookView(item)
			}
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					sheetState = .imagePicker
				} label: {
					Image(systemName: "plus")
				}
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
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView()
	}
}
