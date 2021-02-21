//
//  StoredItem+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData
import UIKit

extension StoredItem {
	
	convenience init(context: NSManagedObjectContext, image: UIImage) {
		let data = image.pngData()
//		let resizedImage = image.resized(toFit: CGSize(side: 200))?.jpegData(compressionQuality: 0.85)
		let resizedImage = image.square(200)?.jpegData(compressionQuality: 0.85)
		self.init(context: context)
		self.placeholderData = resizedImage
		self.id = UUID().uuidString
		self.name = "Image"
		self.data = data
		self.dataType = .image
		self.fileExtension = "png"
		self.timestamp = Date()
	}
	
}
