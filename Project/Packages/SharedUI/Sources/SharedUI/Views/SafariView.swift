//
//  SafariView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 12/3/21.
//

import SafariServices
import SwiftUI

public struct SafariView: UIViewControllerRepresentable {
	let url: URL
	
	public init(url: URL) {
		self.url = url
	}
	
	public func makeUIViewController(context _: Context) -> SFSafariViewController {
		SFSafariViewController(url: url)
	}
	
	public func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}
