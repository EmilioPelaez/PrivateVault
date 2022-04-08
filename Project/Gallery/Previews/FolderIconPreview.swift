//
//  FolderIconPreview.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import SharedUI
import SwiftUI

struct FolderIconPreview: View {
	var body: some View {
		FolderShape()
			.fill(.blue)
			.brightness(0.3)
			.aspectRatio(1.2, contentMode: .fit)
	}
}

struct FolderIconPreview_Previews: PreviewProvider {
	static var previews: some View {
		FolderIconPreview()
			.frame(width: 200, height: 200)
			.preparePreview()
	}
}
