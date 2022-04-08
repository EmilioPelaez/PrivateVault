//
//  GalleryItemPreview.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import SwiftUI

struct GalleryItemPreview: View {
	let kind: GalleryItem.Kind
	let image: Image?
	
	var body: some View {
		if kind == .folder {
			FolderIconPreview()
		} else if let image = image {
			switch kind {
			case .image:
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
			case .file:
				FilePreview(image: image)
			case .url:
				URLIconPreview(image: image)
			case .video:
				VideoIconPreview(image: image)
			case .folder:
				fatalError("Should have been handled in the initial if")
			}
		} else {
			BlankPreview(kind: kind)
		}
	}
}

struct GalleryItemPreview_Previews: PreviewProvider {
	static var previews: some View {
		GalleryItemPreview(kind: .folder, image: Image("file1", bundle: .gallery))
			.frame(width: 200, height: 200)
			.preparePreview()
	}
}
