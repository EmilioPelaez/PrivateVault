//
//  FolderListItem.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 06/08/2021.
//

import SwiftUI

struct FolderListItem: View {
	let name: String
	let isSelected: Bool
	
	var onSelection: (() -> Void)?
	
    var body: some View {
		HStack {
			Text(name)
			Spacer()
			Image(systemName: "checkmark.circle")
				.foregroundColor(isSelected ? .green : .clear)
		}
		.onTapGesture {
			onSelection?()
		}
    }
}

struct FolderListItem_Previews: PreviewProvider {
    static var previews: some View {
		FolderListItem(name: "Documents", isSelected: true)
    }
}
