//
//  InputDisplay.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SharedUI
import SwiftUI

public struct InputDisplay: View {
	@Environment(\.passcodeState) var passcodeState
	
	let input: String
	let codeLength: Int
	
	var color: Color {
		switch passcodeState {
		case .undefined: return .primary
		case .incorrect: return .red
		case .correct: return .green
		}
	}
	
	var backgroundOpacity: Double {
		switch passcodeState {
		case .undefined: return .backgroundAlpha
		case .incorrect, .correct: return .disabledAlpha
		}
	}
	
	public init(input: String, codeLength: Int) {
		self.input = input
		self.codeLength = codeLength
	}
	
	public var body: some View {
		HStack(spacing: 0) {
			ForEach(0 ..< codeLength, id: \.self) { index in
				Text(index < input.count ? "●" : "○")
					.font(.largeTitle)
					.foregroundStyle(.tint)
					.extendHorizontally()
			}
		}
		.largePadding(.vertical)
		.mediumPadding(.horizontal)
		.background(
			RoundedRectangle(cornerRadius: .paddingLarge, style: .continuous)
				.foregroundStyle(.tint)
				.opacity(backgroundOpacity)
		)
		.tint(color)
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
