//
//  ShareSheet.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 3/3/21.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
	let items: [Any]
	
	func makeUIViewController(context _: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
		UIActivityViewController(activityItems: items, applicationActivities: nil)
	}
	
	func updateUIViewController(_: UIActivityViewController, context _: UIViewControllerRepresentableContext<ShareSheet>) {}
}
