//
//  Item.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI
import UIKit

struct Item: Identifiable {
	
	let id: String
	let title: String
	let url: URL
	
	private var _placeholder: Image?
	var placeholder: Image {
		if let _placeholder = _placeholder { return _placeholder }
		return Image(systemName: "xmark.octagon")
	}
}

extension Item {
	init(image: UIImage) {
		let id = UUID().uuidString
		self.id = id
		self.title = ""
		self._placeholder = Image(uiImage: image)
		
		let data = image.pngData()
		let folder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
			.appendingPathComponent("data")
		let url = folder
			.appendingPathComponent(id)
			.appendingPathExtension("png")
		do {
			try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
		} catch {
			print("Uh oh", error)
		}
		
		FileManager.default.createFile(atPath: url.absoluteString, contents: data, attributes: nil)
		
		self.url = url
	}
}


