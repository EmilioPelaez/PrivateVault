//
//  DocumentScanner.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI
import VisionKit

struct DocumentScanner: UIViewControllerRepresentable {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) var presentationMode
	
	let didScan: (VNDocumentCameraScan, Folder?) -> Void
	
	func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
	
	func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
		let documentViewController = VNDocumentCameraViewController()
		documentViewController.delegate = context.coordinator
		return documentViewController
	}
	
	func updateUIViewController(_: VNDocumentCameraViewController, context _: Context) {}
	
	class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
		var parent: DocumentScanner
		
		init(parent: DocumentScanner) {
			self.parent = parent
		}
		
		func documentCameraViewController(_: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
			parent.didScan(scan, parent.appState.currentFolder)
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
