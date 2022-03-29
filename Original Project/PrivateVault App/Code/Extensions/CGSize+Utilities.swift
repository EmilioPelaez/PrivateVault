//
//  CGSize+Utilities.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import CoreGraphics

extension CGSize {
	var aspectRatio: CGFloat {
		width / height
	}

	init(aspectRatio: CGFloat, maxSize size: CGSize) {
		let sizeRatio = size.aspectRatio
		if aspectRatio > sizeRatio {
			self.init(width: size.width, height: size.width / aspectRatio)
		} else {
			self.init(width: size.height * aspectRatio, height: size.height)
		}
	}

	init(side: CGFloat) {
		self.init(width: side, height: side)
	}

	static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
		CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
	}

	static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
		CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
	}
}
