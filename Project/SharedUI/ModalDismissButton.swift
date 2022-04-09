//
//  ModalDismissButton.swift
//  SharedUI
//
//  Created by Emilio Peláez on 09/04/22.
//

import SwiftUI

public struct ModalDismissButton: View {
	let dismiss: () -> Void
	
	public init(_ dismissAction: DismissAction) {
		self.dismiss = dismissAction.callAsFunction
	}
	
	public init(_ dismiss: @escaping () -> Void) {
		self.dismiss = dismiss
	}
	
	public init(_ binding: Binding<Bool>) {
		self.dismiss = { binding.wrappedValue = false }
	}
	
	public var body: some View {
		Button(action: dismiss) {
			Image(systemName: "xmark.circle.fill")
				.foregroundStyle(Color.gray)
				.symbolRenderingMode(.hierarchical)
		}
	}
}

struct ModalDismissButton_Previews: PreviewProvider {
	static var previews: some View {
		ModalDismissButton { }
			.preparePreview()
			.previewFontSizes()
			.previewColorSchemes()
	}
}
