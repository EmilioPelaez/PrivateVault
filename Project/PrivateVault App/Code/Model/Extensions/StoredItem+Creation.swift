//
//  StoredItem+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData
import UIKit

extension StoredItem {
	convenience init(context: NSManagedObjectContext, image: UIImage, filename: String) {
		let data = image.pngData()
		//		let resizedImage = image.resized(toFit: CGSize(side: 200))?.jpegData(compressionQuality: 0.85)
		let resizedImage = image.square(200)?.jpegData(compressionQuality: 0.85)
		self.init(context: context)
		self.placeholderData = resizedImage
		self.id = UUID().uuidString
		self.name = filename
		self.data = data
		self.dataType = .image
		self.fileExtension = "png"
		self.timestamp = Date()
	}

	convenience init(context: NSManagedObjectContext, url: URL) {
		let data = try? Data(contentsOf: url)
		self.init(context: context)
		self.placeholderData = nil
		self.id = UUID().uuidString
		self.name = url.lastPathComponent
		self.data = data
		self.dataType = .unknown
		self.fileExtension = url.pathExtension
		self.timestamp = Date()
	}
}
