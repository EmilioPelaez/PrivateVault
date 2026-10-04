//
//  ShareSheet.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 3/3/21.
//

import SwiftUI
import UIKit

public struct ShareSheet: UIViewControllerRepresentable {
	let items: [Any]
	
	public init(items: [Any]) {
		self.items = items
	}
	
	public func makeUIViewController(context _: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
		UIActivityViewController(activityItems: items, applicationActivities: nil)
	}
	
	public func updateUIViewController(_: UIActivityViewController, context _: UIViewControllerRepresentableContext<ShareSheet>) {}
}
