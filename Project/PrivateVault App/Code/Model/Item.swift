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
	let size: Int
	
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
		self.title = "Puppy!"
		self._placeholder = Image(uiImage: image.resized(toFit: CGSize(side: 300)) ?? UIImage())
		
		do {
			let data = image.pngData()
			let folder = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
				.appendingPathComponent("data")
			let url = folder
				.appendingPathComponent(id)
				.appendingPathExtension("png")
			
			try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
			
			//	For now this will write the data to disk on init and will never be removed
			//	TODO: Write to disk as needed
			try data?.write(to: url)
			
			self.url = url
			self.size = data?.count ?? 0
		} catch {
			print("Uh oh", error)
			self.url = URL(fileURLWithPath: "~")
			self.size = 0
		}
	}
}

extension Item {
	static let example = Item(image: #imageLiteral(resourceName: "file3"))
}

extension Array where Element == Item {
	static let examples = (1...18)
		.map { $0 % 6 + 1 }
		.map { "file\($0)" }
		.compactMap { UIImage(named: $0) }
		.map(Item.init)
}
