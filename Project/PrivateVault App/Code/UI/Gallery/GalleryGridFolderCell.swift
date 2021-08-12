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
		Color.blue.opacity(0.2)
			.frame(height: 80)
			.cornerRadius(10)
			.padding(8)
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
