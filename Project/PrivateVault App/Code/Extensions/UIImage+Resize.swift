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

extension UIImage {
	
	func fixOrientation() -> UIImage {
		if imageOrientation == .up {
			return self
		}
		
		guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else {
			return self
		}
		
		// We need to calculate the proper transformation to make the image upright.
		// We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
		var transform: CGAffineTransform = CGAffineTransform.identity
		
		if imageOrientation == .down || imageOrientation == .downMirrored {
			transform = transform.translatedBy(x: size.width, y: size.height)
			transform = transform.rotated(by: CGFloat(Double.pi))
		}
		
		if imageOrientation == .left || imageOrientation == .leftMirrored {
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
		}
		
		if imageOrientation == .right || imageOrientation == .rightMirrored {
			transform = transform.translatedBy(x: 0, y: size.height)
			transform = transform.rotated(by: CGFloat(-Double.pi / 2.0))
		}
		
		if imageOrientation == .upMirrored || imageOrientation == .downMirrored {
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		}
		
		if imageOrientation == .leftMirrored || imageOrientation == .rightMirrored {
			transform = transform.translatedBy(x: size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		}
		
		// Now we draw the underlying CGImage into a new context, applying the transform
		// calculated above.
		guard let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
																				 bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
																				 space: colorSpace,
																				 bitmapInfo: cgImage.bitmapInfo.rawValue) else {
			return self
		}
		
		ctx.concatenate(transform)
		
		if imageOrientation == .left ||
				imageOrientation == .leftMirrored ||
				imageOrientation == .right ||
				imageOrientation == .rightMirrored {
			ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
		} else {
			ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		}
		
		guard let resultImage = ctx.makeImage() else { return self }
		
		return UIImage(cgImage: resultImage)
	}
}
