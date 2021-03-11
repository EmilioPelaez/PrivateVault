//
//  BlankPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

struct BlankPreview: View {
	let type: StoredItem.DataType
	
	var body: some View {
		ZStack {
			Color(.secondarySystemBackground)
			Image(systemName: type.systemImageName)
				.font(.largeTitle)
		}
	}
}

struct GenericPreviewView_Previews: PreviewProvider {
	static var previews: some View {
		BlankPreview(type: .file)
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
