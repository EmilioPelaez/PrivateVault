//
//  DocumentPicker.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import UIKit
import SwiftUI

final class DocumentPicker: NSObject, UIViewControllerRepresentable {
	var selectDocuments: ([URL]) -> Void

	init(selectDocuments: @escaping ([URL]) -> Void) {
		self.selectDocuments = selectDocuments
	}

	typealias UIViewControllerType = UIDocumentPickerViewController

	lazy var viewController: UIDocumentPickerViewController = {
		// For picked only folder
		let viewController = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .audio, .text, .usdz, .pdf], asCopy: true)
		viewController.allowsMultipleSelection = false
		viewController.delegate = self
		return viewController
	}()

	func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
		viewController.delegate = self
		return viewController
	}

	func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) { }
}

extension DocumentPicker: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		selectDocuments(urls)
	}

	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		controller.dismiss(animated: true)
	}
}
