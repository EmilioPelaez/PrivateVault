//
//  InputDisplay.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SharedUI
import SwiftUI

struct InputDisplay: View {
	@Environment(\.passcodeEntered) var passcodeEntered
	@Environment(\.passcodeLength) var passcodeLength
	@Environment(\.passcodeState) var passcodeState
	
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
	
	var body: some View {
		HStack(spacing: 0) {
			ForEach(0 ..< passcodeLength, id: \.self) { index in
				Text(index < passcodeEntered.count ? "●" : "○")
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
		VStack(spacing: 10) {
			InputDisplay()
				.environment(\.passcodeLength, 4)
			InputDisplay()
				.environment(\.passcodeLength, 6)
		}
		.preparePreview()
		.environment(\.passcodeEntered, "XX")
		.previewLayout(.sizeThatFits)
		.previewColorSchemes()
	}
}
