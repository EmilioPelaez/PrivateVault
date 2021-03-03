//
//  QuickLookView.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import SwiftUI
import QuickLook

struct QuickLookView: UIViewControllerRepresentable {
	let store: DiskStore
	let item: DiskStore.Item

	func makeUIViewController(context: Context) -> UINavigationController {
		let previewController = FilePreviewController(store: store, item: item)
		let action = UIAction { [weak previewController] _ in
			previewController?.dismiss(animated: true)
		}
		previewController.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: action)
		return UINavigationController(rootViewController: previewController)
	}

	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
	
}

final class FilePreviewController: QLPreviewController, QLPreviewItem, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
	
	let store: DiskStore
	let item: DiskStore.Item
	var previewItemURL: URL? { item.url }

	init(store: DiskStore, item: DiskStore.Item) {
		self.store = store
		self.item = item
		super.init(nibName: nil, bundle: nil)
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

	override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
		super.dismiss(animated: flag, completion: completion)
		store.remove(item)
	}
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem { self }
}
