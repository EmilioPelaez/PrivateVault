//
//  BlankPreview.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import Persistence
import SwiftUI

public struct BlankPreview: View {
	let type: StoredItem.DataType
	
	public init(type: StoredItem.DataType) {
		self.type = type
	}
	
	public var body: some View {
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
