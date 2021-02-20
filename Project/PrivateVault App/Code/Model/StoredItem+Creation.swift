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
		self.init(context: context)
		self.id = UUID().uuidString
		self.name = "Image"
		self.data = image.pngData()
		self.dataType = .image
		self.fileExtension = "png"
		
		let resizedImage = image.resized(toFit: CGSize(side: 200))
		self.placeholderData = resizedImage?.jpegData(compressionQuality: 0.85)
	}
	
}
