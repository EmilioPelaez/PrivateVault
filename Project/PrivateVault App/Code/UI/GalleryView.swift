//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct GalleryView: View {
	@State var contentMode: ContentMode = .fill
	@State var selectedItem: Item?
	@State var showPhotoLibrary = false
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
						.onTapGesture { selectedItem = item }
				}
			}
		}
		.navigation(item: $selectedItem, destination: quickLookView)
		.sheet(isPresented: $showPhotoLibrary) {
			ImagePicker(selectImage: selectImage)
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					showPhotoLibrary = true
				} label: {
					Image(systemName: "plus")
				}
			}
		}
	}

	func quickLookView(_ item: Item) -> some View {
		let data = try! Data(contentsOf: URL(string: "https://img.ibxk.com.br/2020/08/07/07115418185111.jpg?w=1120&h=420&mode=crop&scale=both")!)
		let documentsPath = NSSearchPathForDirectoriesInDomains(.documentationDirectory,.userDomainMask,true)
		let theFile: FileHandle? = FileHandle(forWritingAtPath: "\(documentsPath)/caramelo.jpg")
		theFile?.write(data)
		theFile?.closeFile()
		return QuickLookView(title: item.id.description, url: URL(fileURLWithPath: "\(documentsPath)/caramelo.jpg"))
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
