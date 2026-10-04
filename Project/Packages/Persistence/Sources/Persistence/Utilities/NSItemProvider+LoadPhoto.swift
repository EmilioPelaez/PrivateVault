//
//  NSItemProvider+LoadPhoto.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import UIKit

public extension NSItemProvider {
	
	private func loadImage(completion: @escaping (UIImage?) -> Void) {
		guard canLoadObject(ofClass: UIImage.self) else {
			return completion(nil)
		}
		loadObject(ofClass: UIImage.self) { object, _ in
			guard let image = object as? UIImage else {
				return completion(nil)
			}
			completion(image)
		}
	}
	
}
