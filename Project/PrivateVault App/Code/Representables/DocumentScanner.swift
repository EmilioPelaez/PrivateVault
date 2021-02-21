//
//  DocumentScanner.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import UIKit
import SwiftUI
import Vision
import VisionKit

struct DocumentScanner: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	var selectScan: (UIImage) -> Void
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
		let documentViewController = VNDocumentCameraViewController()
		documentViewController.delegate = context.coordinator
		return documentViewController
	}
	
	func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
	
	class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
		var parent: DocumentScanner
		
		init(parent: DocumentScanner) {
			self.parent = parent
		}
		
		func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
			let extractedImage = extractImages(from: scan).first.map(UIImage.init)!
			parent.selectScan(extractedImage)
			parent.presentationMode.wrappedValue.dismiss()
		}
		
		fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
			var extractedImages = [CGImage]()
			for index in 0..<scan.pageCount {
				let extractedImage = scan.imageOfPage(at: index)
				guard let cgImage = extractedImage.cgImage else { continue }
				extractedImages.append(cgImage)
			}
			return extractedImages
		}
	}
}
