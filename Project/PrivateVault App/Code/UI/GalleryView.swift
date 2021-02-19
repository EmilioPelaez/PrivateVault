//
//  GalleryView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct GalleryView: View {
	
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	var data: [Item] = [Color.red, .green, .blue, .red, .green, .blue, .red, .green, .blue]
		.map(Item.init)
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(data) {
					$0.color
						.aspectRatio(1, contentMode: .fill)
				}
			}
		}
	}
}

struct GalleryView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryView()
	}
}
