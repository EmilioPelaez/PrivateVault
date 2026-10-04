//
//  VNDocumentCameraScan+PDF.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import PDFKit
import VisionKit

public extension VNDocumentCameraScan {
	
	func generatePDF() -> PDFDocument {
		let document = PDFDocument()
		
		(0 ..< pageCount)
			.lazy
			.map { self.imageOfPage(at: $0) }
			.compactMap(PDFPage.init)
			.enumerated()
			.map { ($1, $0) }
			.forEach(document.insert)
		
		return document
	}
	
}
