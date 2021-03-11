//
//  QuickLookView.swift
//  PrivateVault
//
//  Created by Ian Manor on 19/02/21.
//

import SwiftUI
import QuickLook

struct QuickLookView: UIViewControllerRepresentable {
	struct Selection: Identifiable {
		let id = UUID()
		let items: [StoredItem]
		let selectedIndex: Int
	}
	
	let store: DiskStore
	let selection: Selection

	func makeUIViewController(context: Context) -> UINavigationController {
		let previewController = FilePreviewController(store: store, selection: selection)
		let action = UIAction { [weak previewController] _ in
			previewController?.dismiss(animated: true)
		}
		previewController.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: action)
		return UINavigationController(rootViewController: previewController)
	}

	func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
	
}

final class FilePreviewController: QLPreviewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
	
	class PreviewItem: NSObject, QLPreviewItem {
		let index: Int
		let storedItem: StoredItem
		var diskItem: DiskStore.Item?
		
		var previewItemURL: URL?
		var previewItemTitle: String? { storedItem.name }
		
		init(index: Int, item: StoredItem, url: URL?) {
			self.index = index
			self.storedItem = item
			self.previewItemURL = url
		}
	}
	
	let store: DiskStore
	let items: [PreviewItem]
	
	private let initialIndex: Int
	private var indicesLoaded = IndexSet()
	private var observer: Any?

	init(store: DiskStore, selection: QuickLookView.Selection) {
		self.store = store
		self.items = selection.items
			.enumerated()
			.map {
				PreviewItem(index: $0, item: $1, url: try? store.url(for: $1))
			}
		self.initialIndex = selection.selectedIndex
		super.init(nibName: nil, bundle: nil)
		
		observer = observe(\.currentPreviewItemIndex, options: [.old, .new]) { [weak self] _, change in
			guard let newValue = change.newValue else { return }
			self?.currentPreviewItemIndexDidChange(newValue)
		}
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		dataSource = self
		currentPreviewItemIndex = initialIndex
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		items.map(\.storedItem).forEach(store.remove)
	}
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int { items.count }

	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		items[index]
	}
	
	private func currentPreviewItemIndexDidChange(_ index: Int) {
		guard (0..<items.count).contains(index) else { return }
		guard !indicesLoaded.contains(index) else { return }
		indicesLoaded.insert(index)
		loadItem(items[index]) { _ in
			self.refreshCurrentPreviewItem()
		}
	}
	
	private func loadItem(_ item: PreviewItem, completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
		store.add(item.storedItem) { result in
			switch result {
			case .success(let diskItem):
				item.diskItem = diskItem
				completion(.success(()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
