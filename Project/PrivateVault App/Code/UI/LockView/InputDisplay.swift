//
//  InputDisplay.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct InputDisplay: View {
	let codeLength: Int
	@Binding var input: String
	let textColor: Color
	
	var body: some View {
		HStack(spacing: 0) {
			ForEach(0..<codeLength) { index in
				Group {
					if index == 0 {
						Spacer()
					}
					if index < input.count {
						Text("●")
					} else {
						Text("○")
					}
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
		InputDisplay(codeLength: 4, input: .constant("X"), textColor: .red)
			.previewLayout(.sizeThatFits)
	}
}
