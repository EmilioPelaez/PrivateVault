//
//  BlankPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct BlankPreview: View {
	let kind: GalleryItem.Kind
	
	var body: some View {
		ZStack {
			Image(systemName: kind.systemImageName)
				.font(.largeTitle)
		}
	}
}

struct GenericPreviewView_Previews: PreviewProvider {
	static var previews: some View {
		BlankPreview(kind: .file)
			.frame(width: 200)
			.preparePreview()
	}
}
