//
//  GalleryGridFolder.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 17/07/2021.
//

import SwiftUI

struct GalleryGridFolderCell: View {
	enum Style {
		case compact
		case folder
	}
	let folder: Folder
	let style: Style
	
	var body: some View {
		switch style {
		case .compact:
			HStack {
				Image(systemName: "folder.fill")
					.folderStyle()
					.font(.title)
				Text(folder.name ?? "Untitled Folder")
					.lineLimit(1)
					.font(.headline)
				Spacer()
			}
			.padding(8)
			.background(Color(.quaternarySystemFill))
			.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
		case .folder:
			FolderShape()
						.folderStyle()
						.aspectRatio(contentMode: .fit)
						.overlay(
							Text(folder.name ?? "Untitled Folder")
								.font(.headline)
								.multilineTextAlignment(.center)
								.foregroundColor(.black)
								.padding(4)
						)
		}
	}
}

struct GalleryGridFolder_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		GalleryGridFolderCell(folder: preview.folder, style: .compact)
		GalleryGridFolderCell(folder: preview.folder, style: .folder)
	}
}
