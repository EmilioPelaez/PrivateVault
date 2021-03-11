//
//  ItemPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct ItemPreview: View {
	let item: StoredItem
	
	var body: some View {
		if let image = PreviewCache.shared.cachedImage(for: item) {
			switch item.dataType {
			case .file:
				FilePreview(image: image)
			case .image:
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
			case .video, .url:
				ItemIconPreview(image: image, type: item.dataType)
			}
		} else {
			BlankPreview(type: item.dataType)
		}
	}
}

struct ItemPreview_Previews: PreviewProvider {
	static var previews: some View {
		ItemPreview(item: PreviewEnvironment().item)
	}
}
