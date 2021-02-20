//
//  StoredItem+Properties.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import Foundation
import SwiftUI
import UIKit

extension StoredItem {
	
	var url: URL {
		guard let data = data, let fileExtension = fileExtension else { return URL(fileURLWithPath: "") }
		do {
			let folder = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
				.appendingPathComponent("data")
			let url = folder
				.appendingPathComponent("temp")
				.appendingPathExtension(fileExtension)
			
			try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
			
			//	For now this will write the data to disk on init and will never be removed
			//	TODO: Write to disk as needed
			try data.write(to: url)
			return url
		} catch {
			return URL(fileURLWithPath: "")
		}
	}
	
	var placeholder: Image {
		Image(uiImage:
			placeholderData.flatMap { UIImage(data: $0) } ??
				UIImage(systemName: "xmark.octagon.fill") ??
				UIImage()
		)
	}
	
}
