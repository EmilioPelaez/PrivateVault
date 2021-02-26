//
//  Spinner.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import SwiftUI

struct Spinner: View {
	@State var isAnimating = false
	
	var body: some View {
		ZStack {
			ForEach(0..<9) { index in
				Circle()
					.fill(Color.primary)
					.frame(width: 4, height: 4)
					.offset(x: 0, y: -8)
					.rotationEffect(.degrees(Double(index) * -37))
					.opacity(1 - (Double(index) * 0.1))
			}
		}
		.frame(width: 22, height: 22)
		.rotationEffect(.degrees(isAnimating ? 360 : 0))
		.animation(
			Animation.linear(duration: 1)
				.repeatForever(autoreverses: false)
		)
		.onAppear { isAnimating = true }
	}
}

struct Spinner_Previews: PreviewProvider {
	static var previews: some View {
		Spinner()
			.previewLayout(.fixed(width: 100, height: 100))
	}
}
