//
//  EmptyFolderView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 17/10/21.
//

import SwiftUI

struct EmptyFolderView: View {
	var body: some View {
		VStack(spacing: 30) {
			FolderShape()
				.folderStyle()
				.frame(width: 150, height: 150 / FolderShape.preferredAspectRatio)
			VStack(spacing: 15) {
				Text("Your folder is empty!")
					.font(.title2)
					.multilineTextAlignment(.center)
				Text("Add some files by holding over an existing item or folder and tap \"Move\"")
					.multilineTextAlignment(.center)
			}
		}
		.frame(maxWidth: 300)
		.padding(.bottom, 100)
	}
}

struct EmptyFolderView_Previews: PreviewProvider {
	static var previews: some View {
		EmptyFolderView()
	}
}
