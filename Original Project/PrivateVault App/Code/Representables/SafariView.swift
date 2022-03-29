//
//  SafariView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 12/3/21.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
	let url: URL
	
	func makeUIViewController(context _: Context) -> SFSafariViewController {
		SFSafariViewController(url: url)
	}
	
	func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}
