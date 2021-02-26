//
//  StoredItem+Creation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreData
import UIKit

extension StoredItem {
	
	convenience init(context: NSManagedObjectContext, data: Data, previewData: Data? = nil, type: DataType, name: String, fileExtension: String) {
		self.init(context: context)
		self.id = UUID().uuidString
		self.data = data
		self.previewData = previewData
		self.dataType = type
		self.name = name
		self.fileExtension = fileExtension
		self.timestamp = Date()
	}
	
	convenience init(context: NSManagedObjectContext, image: UIImage, name: String, extension: String) {
		let data = image.pngData()
		let resizedImage = image.square(200)?.jpegData(compressionQuality: 0.85)
		self.init(context: context)
		self.id = UUID().uuidString
		self.data = data
		self.previewData = resizedImage
		self.dataType = .image
		self.name = name
		self.fileExtension = "png"
		self.timestamp = Date()
	}
}
