//
//  InputDisplay.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SharedUI
import SwiftUI

public struct InputDisplay: View {
	let input: String
	let codeLength: Int
	
	public init(input: String, codeLength: Int) {
		self.input = input
		self.codeLength = codeLength
	}
	
	public var body: some View {
		HStack(spacing: 0) {
			ForEach(0 ..< codeLength, id: \.self) { index in
				Group {
					Text(index < input.count ? "●" : "○")
						.font(.largeTitle)
						.foregroundStyle(.tint)
				}
				.extendHorizontally()
				.transition(.scale(scale: .ulpOfOne, anchor: .trailing))
			}
		}
		.largePadding(.vertical)
		.mediumPadding(.horizontal)
		.background(
			RoundedRectangle(cornerRadius: .paddingLarge, style: .continuous)
				.foregroundStyle(.tint)
				.opacity(.backgroundAlpha)
		)
	}
}

struct InputDisplay_Previews: PreviewProvider {
	static var previews: some View {
		VStack(spacing: 0) {
			InputDisplay(input: "X", codeLength: 4)
				.preparePreview()
			
			InputDisplay(input: "XX", codeLength: 6)
				.preparePreview()
		}
		.previewLayout(.sizeThatFits)
		.previewColorSchemes()
	}
}
