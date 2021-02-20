//
//  UIImage+Resize.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import UIKit

extension UIImage {
	
	func resized(toFit size: CGSize) -> UIImage? {
		let newSize = CGSize(aspectRatio: self.size.aspectRatio, maxSize: size)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		self.draw(in: CGRect(origin: .zero, size: newSize))
		guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
			assertionFailure("Unable to get image from context")
			return nil
		}
		return image
	}
	
	func square(_ side: CGFloat) -> UIImage? {
		let size = CGSize(side: side)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		
		let rect: CGRect
		if self.size.width > self.size.height {
			let scale = self.size.height / side
			let newSize = self.size / scale
			rect = CGRect(origin: CGPoint(x: (side - newSize.width) / 2, y: 0), size: newSize)
		} else {
			let scale = self.size.width / side
			let newSize = self.size / scale
			rect = CGRect(origin: CGPoint(x: 0, y: (side - newSize.height) / 2), size: newSize)
		}
		
		self.draw(in: rect)
		guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
			assertionFailure("Unable to get image from context")
			return nil
		}
		return image
	}
	
}
