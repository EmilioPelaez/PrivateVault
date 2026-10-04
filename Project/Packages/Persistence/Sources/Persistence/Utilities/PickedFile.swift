//
//  PickedFile.swift
//  Persistence
//
//  Created by Emilio Peláez on 4/10/26.
//

import CoreTransferable
import Foundation
import UniformTypeIdentifiers

//	A temporary copy of a file selected in the photos picker, call `remove` once it's been stored
struct PickedFile: Transferable {
	let url: URL
	
	static var transferRepresentation: some TransferRepresentation {
		FileRepresentation(importedContentType: .image) { try PickedFile(received: $0) }
		FileRepresentation(importedContentType: .audiovisualContent) { try PickedFile(received: $0) }
	}
	
	init(received: ReceivedTransferredFile) throws {
		let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
		let url = folder.appendingPathComponent(received.file.lastPathComponent)
		try FileManager.default.copyItem(at: received.file, to: url)
		self.url = url
	}
	
	func remove() {
		try? FileManager.default.removeItem(at: url.deletingLastPathComponent())
	}
}
