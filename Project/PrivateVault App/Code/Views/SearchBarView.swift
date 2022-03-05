//
//  SearchBarView.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

struct SearchBarView: View {
	@Binding var text: String
	var placeholder: String?

	var body: some View {
		HStack {
			HStack {
				Image(systemName: "magnifyingglass")
					.font(.headline)
					.foregroundColor(Color(.secondaryLabel))
				TextField(placeholder ?? "Search", text: $text)
				if !text.isEmpty {
					Image(systemName: "multiply.circle.fill")
						.foregroundColor(Color(.secondaryLabel))
						.onTapGesture { self.text = "" }
				}
			}
			.padding(8)
			.background(
				RoundedRectangle(cornerRadius: 12).foregroundColor(Color(.tertiarySystemFill))
			)
		}
		.animation(.linear(duration: 0.16))
	}
}
