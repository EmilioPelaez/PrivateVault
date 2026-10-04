//
//  DocumentScanner.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import Middleware
import Persistence
import SwiftUI
import VisionKit

public struct DocumentScanner: UIViewControllerRepresentable {
	@EnvironmentObject private var appState: AppState
	@Environment(\.presentationMode) var presentationMode
	
	let didScan: (VNDocumentCameraScan, Folder?) -> Void
	
	public init(didScan: @escaping (VNDocumentCameraScan, Folder?) -> Void) {
		self.didScan = didScan
	}
	
	public func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
	
	public func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
		let documentViewController = VNDocumentCameraViewController()
		documentViewController.delegate = context.coordinator
		return documentViewController
	}
	
	public func updateUIViewController(_: VNDocumentCameraViewController, context _: Context) {}
	
	public class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
		var parent: DocumentScanner
		
		init(parent: DocumentScanner) {
			self.parent = parent
		}
		
		public func documentCameraViewController(_: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
			parent.didScan(scan, parent.appState.currentFolder)
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
