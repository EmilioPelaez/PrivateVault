//
//  StoredItem+Properties.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

extension StoredItem {
	func generatePreview() -> Image? {
		previewData.flatMap(UIImage.init).map(Image.init)
	}
	
	var searchText: String {
		let tags = tags as? Set<Tag>
		let tagSearch = tags?.compactMap(\.name).joined(separator: " ")
		return [tagSearch, name].compactMap { $0 }.joined(separator: " ")
	}
	
	var tagsText: String {
		guard let tags = tags as? Set<Tag>, !tags.isEmpty else {
			return "No Tags"
		}
		return tags.map(\.name).compactMap { $0 }.sorted().joined(separator: ", ")
	}
}
