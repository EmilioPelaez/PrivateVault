//
//  InputDisplay.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

public struct InputDisplay: View {
	@Binding var input: String
	let codeLength: Int
	let textColor: Color
	let displayColor: Color?
	
	public init(input: Binding<String>, codeLength: Int, textColor: Color, displayColor: Color?) {
		self._input = input
		self.codeLength = codeLength
		self.textColor = textColor
		self.displayColor = displayColor
	}
	
	public var body: some View {
		HStack(spacing: 0) {
			Spacer()
			ForEach(0 ..< codeLength, id: \.self) { index in
				Group {
					Text(index < input.count ? "●" : "○")
					Spacer()
				}
				.font(.largeTitle)
				.foregroundColor(textColor)
				.transition(.scale(scale: .ulpOfOne, anchor: .trailing))
			}
		}
		.padding(.vertical, 20)
		.background(
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(displayColor?.opacity(0.2) ?? Color(.tertiarySystemFill))
		)
	}
}

struct InputDisplay_Previews: PreviewProvider {
	static var previews: some View {
		InputDisplay(input: .constant("X"), codeLength: 4, textColor: .primary, displayColor: nil)
			.previewLayout(.sizeThatFits)

		InputDisplay(input: .constant("XX"), codeLength: 6, textColor: .primary, displayColor: nil)
			.previewLayout(.sizeThatFits)
	}
}
