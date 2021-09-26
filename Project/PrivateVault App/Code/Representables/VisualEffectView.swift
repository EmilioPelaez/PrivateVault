//
//  VisualEffectView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
	let style: UIBlurEffect.Style

	func makeUIView(context _: Context) -> UIVisualEffectView {
		UIVisualEffectView(effect: UIBlurEffect(style: style))
	}

	func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}
