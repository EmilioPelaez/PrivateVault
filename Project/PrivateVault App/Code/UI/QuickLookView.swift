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
		let previewController = FilePreviewController(url: url)
		previewController.navigationItem.title = title
		let doneButton = UIBarButtonItem(title: "Cancel",
										 style: .done,
										 target: previewController,
										 action: #selector(previewController.dismissModal))
		previewController.navigationItem.leftBarButtonItem = doneButton
		return UINavigationController(rootViewController: previewController)
	}

	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

final class FilePreviewController: QLPreviewController, QLPreviewItem, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
	var previewItemURL: URL?

	init(url: URL) {
		super.init(nibName: nil, bundle: nil)
		previewItemURL = url
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

	func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
		return 1
	}

	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		return self
	}
}

extension UIViewController {
	@objc
	public func dismissModal() {
		self.dismiss(animated: true, completion: nil)
	}
}
