//
//  ImportActionButton.swift
//  ActionButtons
//
//  Created by Emilio Peláez on 26/04/22.
//

import HierarchyResponder
import SharedUI
import SwiftUI

extension ImportSelectionView {
	struct ImportButton: View {
		let type: ImportType
		let height: CGFloat

		var body: some View {
			EventButton(ImportEvent(type: type)) {
				VStack(spacing: 2) {
					Image(systemName: type.systemName)
						.font(.system(size: height / 2))
						.frame(width: height, height: height)
						.background(Circle().fill(Color.white))
						.foregroundColor(.blue)
				}
			}
		}
	}
}

struct ImportActionButton_Previews: PreviewProvider {
	static var previews: some View {
		ImportSelectionView.ImportButton(type: .camera, height: 60)
			.preparePreview()
	}
}
