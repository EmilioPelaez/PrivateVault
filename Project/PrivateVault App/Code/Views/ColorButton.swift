//
//  ColorButton.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 1/3/21.
//

import SwiftUI

struct ColorButton: View {
	let color: Color
	let imageName: String
	let action: () -> Void
	
	var body: some View {
		ZStack {
			Circle()
				.fill(color)
				.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
			Button(action: action) {
				Group {
					Image(systemName: imageName)
				}
				.font(.system(size: 30))
				.foregroundColor(.white)
				.transition(.opacity)
			}
			.frame(width: 60, height: 60)
		}
		.frame(width: 60, height: 60)
	}
}

struct ColorButton_Previews: PreviewProvider {
	static var previews: some View {
		ColorButton(color: .red, imageName: "trash") { }
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
