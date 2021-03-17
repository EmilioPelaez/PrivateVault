//
//  ItemSelectionView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 1/3/21.
//

import SwiftUI

struct ItemSelectionView: View {
	let selected: Bool
	
	var body: some View {
		ZStack {
			Circle()
				.fill(Color(.systemBackground))
				.shadow(color: Color(white: 0, opacity: 0.4), radius: 2, x: 0, y: 1)
				.opacity(0.5)
			Circle()
				.fill(Color(.systemBlue))
				.padding(3)
				.scaleEffect(selected ? 1 : .ulpOfOne)
			Image(systemName: "checkmark")
				.font(.system(size: 10, weight: .bold))
				.foregroundColor(Color(.systemBackground))
				.scaleEffect(selected ? 1 : .ulpOfOne)
		}
		.frame(width: 25, height: 25)
	}
}

struct ItemSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		ItemSelectionView(selected: true)
			.padding()
			.previewLayout(.sizeThatFits)
		
		ItemSelectionView(selected: false)
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
