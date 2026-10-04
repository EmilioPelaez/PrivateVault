//
//  RadioButton.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

public struct RadioButton: View {
	let selected: Bool
	let size: CGFloat
	let color: Color
	
	public init(selected: Bool, size: CGFloat, color: Color) {
		self.selected = selected
		self.size = size
		self.color = color
	}
	
	public var body: some View {
		ZStack {
			Circle()
				.stroke(color, lineWidth: 2)
				.frame(width: size, height: size)
			Circle()
				.fill(color)
				.frame(width: size - 4, height: size - 4)
				.scaleEffect(selected ? 1 : .ulpOfOne)
		}
	}
}

struct RadioButton_Previews: PreviewProvider {
	static var previews: some View {
		RadioButton(selected: true, size: 24, color: .blue)
			.previewLayout(.sizeThatFits)
		RadioButton(selected: false, size: 24, color: .blue)
			.previewLayout(.sizeThatFits)
	}
}
