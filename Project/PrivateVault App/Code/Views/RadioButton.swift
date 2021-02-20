//
//  RadioButton.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct RadioButton: View {
	let selected: Bool
	let size: CGFloat
	let color: Color
	let action: () -> Void
	
	var body: some View {
		ZStack {
			Circle()
				.stroke(color, lineWidth: 2)
				.frame(width: size, height: size)
			Circle()
				.fill(Color.blue)
				.frame(width: size - 4, height: size - 4)
				.scaleEffect(selected ? 1 : 0)
		}
		.onTapGesture(perform: action)
	}
}

struct RadioButton_Previews: PreviewProvider {
	static var previews: some View {
		RadioButton(selected: true, size: 24, color: .blue) { }
			.previewLayout(.sizeThatFits)
		RadioButton(selected: false, size: 24, color: .blue) { }
			.previewLayout(.sizeThatFits)
	}
}
