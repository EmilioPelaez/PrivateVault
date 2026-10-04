//
//  DocumentPicker.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import Middleware
import Persistence
import SwiftUI
import UIKit

public struct DocumentPicker: UIViewControllerRepresentable {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) var presentationMode
	var selectDocuments: ([URL], Folder?) -> Void
	
	public init(selectDocuments: @escaping ([URL], Folder?) -> Void) {
		self.selectDocuments = selectDocuments
	}
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
		let viewController = UIDocumentPickerViewController(forOpeningContentTypes: .supportedTypes, asCopy: true)
		viewController.allowsMultipleSelection = true
		viewController.delegate = context.coordinator
		return viewController
	}

	public func updateUIViewController(_: UIDocumentPickerViewController, context _: UIViewControllerRepresentableContext<DocumentPicker>) {}
	
	public func makeCoordinator() -> Coordinator { Coordinator(self) }

	public class Coordinator: NSObject, UIDocumentPickerDelegate {
		var parent: DocumentPicker

		init(_ parent: DocumentPicker) {
			self.parent = parent
		}

		public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
			parent.selectDocuments(urls, parent.appState.currentFolder)
		}

		public func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
