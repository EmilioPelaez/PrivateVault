//
//  View+FolderStyle.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 13/10/21.
//

import SwiftUI

extension Shape {
	func folderStyle() -> some View {
		self
			.fill(.blue)
			.brightness(0.3)
	}
}

extension View {
	func folderStyle() -> some View {
		self
			.foregroundColor(.blue)
			.brightness(0.3)
	}
}
