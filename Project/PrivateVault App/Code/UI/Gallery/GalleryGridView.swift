//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView: View {
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	@Binding var data: [Item]
	@Binding var contentMode: ContentMode
	@Binding var showDetails: Bool
	let selection: (Item) -> Void
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(data) { item in
					GalleryGridCell(item: item, contentMode: $contentMode, showDetails: $showDetails, selection: selection)
				}
			}
		}
	}
}

struct GalleryGridView_Previews: PreviewProvider {
	static let data: [Item] = (1...6)
		.map { "file\($0)" }
		.map { Image($0) }
		.map(Item.init)
	static var previews: some View {
		GalleryGridView(data: .constant(data), contentMode: .constant(.fill), showDetails: .constant(true)) { _ in }
		
		GalleryGridView(data: .constant(data), contentMode: .constant(.fill), showDetails: .constant(false)) { _ in }
	}
}
