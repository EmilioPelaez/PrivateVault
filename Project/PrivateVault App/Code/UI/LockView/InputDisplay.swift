//
//  InputDisplay.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct InputDisplay: View {
	@EnvironmentObject var settings: UserSettings
	var codeLength: Int { settings.password.count }
	@Binding var input: String
	let textColor: Color
	
	var body: some View {
		HStack(spacing: 0) {
			Spacer()
			ForEach(0..<codeLength) { index in
				Group {
					Text(index < input.count ? "●" : "○")
					Spacer()
				}
				.font(.largeTitle)
				.foregroundColor(textColor)
			}
		}
		.padding(.vertical, 20)
		.background(
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color(.tertiarySystemFill))
		)
	}
}

struct InputDisplay_Previews: PreviewProvider {
	static var previews: some View {
		InputDisplay(input: .constant("X"), textColor: .red)
			.previewLayout(.sizeThatFits)
	}
}
