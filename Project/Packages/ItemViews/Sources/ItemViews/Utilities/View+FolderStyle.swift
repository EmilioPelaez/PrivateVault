//
//  View+FolderStyle.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/10/21.
//

import SwiftUI

public extension Shape {
	func folderStyle() -> some View {
		fill(.blue)
			.brightness(0.3)
	}
}

public extension View {
	func folderStyle() -> some View {
		foregroundColor(.blue)
			.brightness(0.3)
	}
}
