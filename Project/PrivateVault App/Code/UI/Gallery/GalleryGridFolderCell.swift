//
//  GalleryGridFolder.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 17/07/2021.
//

import SwiftUI

struct GalleryGridFolderCell: View {
	let folder: Folder
	
    var body: some View {
		FolderShape()
			.fill(Color.blue)
			.opacity(0.2)
			.aspectRatio(contentMode: .fit)
			.overlay(
				Text(folder.name ?? "Untitled")
					.font(.subheadline)
					.bold()
					.multilineTextAlignment(.center)
					.padding(8)
			)
	}
}

struct GalleryGridFolder_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
    static var previews: some View {
		GalleryGridFolderCell(folder: preview.folder)
    }
}
