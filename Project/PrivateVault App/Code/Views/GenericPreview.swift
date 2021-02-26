//
//  GenericPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct GenericPreview: View {
	let imageName: String
	
	var body: some View {
		ZStack {
			Color(.secondarySystemBackground)
			Image(systemName: imageName)
				.font(.largeTitle)
		}
	}
}

struct GenericPreviewView_Previews: PreviewProvider {
	static var previews: some View {
		GenericPreview(imageName: "doc")
	}
}
