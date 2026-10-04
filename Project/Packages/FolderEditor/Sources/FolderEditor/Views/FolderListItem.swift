//
//  FolderListItem.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 06/08/2021.
//

import ItemViews
import SharedUI
import SwiftUI

public struct FolderListItem: View {
	let name: String
	let isSelected: Bool
	let isSelectable: Bool
	let action: () -> Void
	
	public init(name: String, isSelected: Bool, isSelectable: Bool, action: @escaping () -> Void) {
		self.name = name
		self.isSelected = isSelected
		self.isSelectable = isSelectable
		self.action = action
	}
	
	public var body: some View {
		Button(action: action) {
			HStack {
				FolderShape()
					.folderStyle()
					.frame(width: 20 * FolderShape.preferredAspectRatio, height: 20)
				Text(name)
					.foregroundColor(.primary)
				Spacer()
				RadioButton(selected: isSelected, size: 16, color: .blue)
			}
		}
		.disabled(!isSelectable)
		.saturation(isSelectable ? 1 : 0)
	}
}

struct FolderListItem_Previews: PreviewProvider {
	static var previews: some View {
		FolderListItem(name: "Documents", isSelected: true, isSelectable: false) {}
	}
}
