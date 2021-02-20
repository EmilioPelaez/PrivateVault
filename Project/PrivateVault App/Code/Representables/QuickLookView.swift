//
//  QuickLookView.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import UIKit
import SwiftUI
import QuickLook

struct QuickLookView: UIViewControllerRepresentable {
	let title: String
	let url: URL

	func makeUIViewController(context: Context) -> UINavigationController {
		let previewController = FilePreviewController(url: url, title: title)
		let action = UIAction { [weak previewController] _ in
			previewController?.dismiss(animated: true)
		}
		previewController.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: action)
		return UINavigationController(rootViewController: previewController)
	}

	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

final class FilePreviewController: QLPreviewController, QLPreviewItem, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
	var previewItemURL: URL?
	var previewItemTitle: String?

	init(url: URL, title: String) {
		super.init(nibName: nil, bundle: nil)
		previewItemURL = url
		previewItemTitle = title
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		self.dataSource = self
	}
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem { self }
	
}
