//
//  ImportProcessView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import SwiftUI

public struct ImportProcessView: View {
	public init() {}
	
	public var body: some View {
		HStack {
			Text("Processing...")
				.font(.headline)
//			Spinner() Spins weirdly when run, works on previews
		}
		.padding()
		.padding(.horizontal, 6)
		.background(Color(.secondarySystemBackground))
		.clipShape(Capsule())
		.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
	}
}

struct ImportProcessView_Previews: PreviewProvider {
	static var previews: some View {
		ImportProcessView()
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
