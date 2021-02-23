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
			let folder = try FileManager.default.url(
				for: .cachesDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: false
			)
				.appendingPathComponent("data")
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

	var systemName: String {
		switch url.pathExtension {
		case "pdf", "doc":
			return "doc.richtext"
		case "txt":
			return "doc.text"
		case "mp4":
			return "video"
		case "usdz":
			return "arkit"
		case "zip":
			return "doc.zipper"
		default:
			return "xmark.octagon.fill"
		}
	}

	@ViewBuilder
	var placeholder: some View {
		if let placeholderImage = placeholderData.flatMap({ UIImage(data: $0) }) {
			Image(uiImage: placeholderImage)
				.resizable()
		} else {
			VStack {
				Spacer()
				HStack {
					Spacer()
					Image(systemName: systemName)
						.font(.largeTitle)
					Spacer()
				}
				Spacer()
			}
		}
	}

	var searchText: String {
		let tags = self.tags as? Set<Tag>
		let tagSearch = tags?.compactMap(\.name).joined(separator: " ")
		return [tagSearch, name].compactMap { $0 }.joined(separator: " ")
	}
}
