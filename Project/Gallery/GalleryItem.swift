//
//  GalleryItem.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import Foundation

struct GalleryItem: Identifiable {
	enum Kind {
		case folder
		case file
		case image
		case video
		case url
	}
	
	let id: String
	let title: String
	let subtitle: String
	let kind: Kind
	
}

extension GalleryItem.Kind {
	var systemImageName: String {
		switch self {
		case .folder: return "folder"
		case .file: return "doc"
		case .image: return "photo"
		case .video: return "video"
		case .url: return "link"
		}
	}
}
