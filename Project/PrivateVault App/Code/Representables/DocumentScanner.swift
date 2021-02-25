//
//  DocumentScanner.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI
import VisionKit

struct DocumentScanner: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	let didScan: (VNDocumentCameraScan) -> Void
	
	func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
	
	func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
		let documentViewController = VNDocumentCameraViewController()
		documentViewController.delegate = context.coordinator
		return documentViewController
	}
	
	func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
	
	class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
		var parent: DocumentScanner
		
		init(parent: DocumentScanner) {
			self.parent = parent
		}
		
		func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
			parent.didScan(scan)
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
