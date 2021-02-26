//
//  StoredItem+Properties.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

extension StoredItem {
	var url: URL {
		guard let data = data, let fileExtension = fileExtension else { return URL(fileURLWithPath: "") }
		do {
			let folder = FileManager.default.temporaryDirectory.appendingPathComponent("data")
			let url = folder
				.appendingPathComponent("temp")
				.appendingPathExtension(fileExtension)
			
			try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
			
			try data.write(to: url)
			return url
		} catch {
			return URL(fileURLWithPath: "")
		}
	}
	
	func generatePreview() -> Image? {
		previewData.flatMap(UIImage.init).map(Image.init)
	}
	
	var searchText: String {
		let tags = self.tags as? Set<Tag>
		let tagSearch = tags?.compactMap(\.name).joined(separator: " ")
		return [tagSearch, name].compactMap { $0 }.joined(separator: " ")
	}
}
