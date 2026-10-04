//
//  ItemPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import Persistence
import SwiftUI

public struct ItemPreview: View {
	let item: StoredItem
	
	public init(item: StoredItem) {
		self.item = item
	}
	
	public var body: some View {
		if let image = PreviewCache.shared.cachedImage(for: item) {
			switch item.dataType {
			case .file:
				FilePreview(image: image)
			case .image:
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
			case .video:
				VideoIconPreview(image: image)
			case .url:
				URLIconPreview(image: image)
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
