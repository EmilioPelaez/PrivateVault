//
//  GalleryItem.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import Foundation

public struct GalleryItem: Identifiable {
	public enum Kind {
		case folder
		case file
		case image
		case video
		case url
	}
	
	public let id: String
	public let title: String
	public let subtitle: String
	public let kind: Kind
	
	public init(id: String, title: String, subtitle: String, kind: GalleryItem.Kind) {
		self.id = id
		self.title = title
		self.subtitle = subtitle
		self.kind = kind
	}
	
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
