//
//  ImportType.swift
//  SharedUI
//
//  Created by Emilio Peláez on 26/04/22.
//

import Foundation
import HierarchyResponder

public enum ImportType: CaseIterable, Identifiable {
	case camera
	case album
	case document
	case scan
	case clipboard

	public var systemName: String {
		switch self {
		case .camera: return "camera"
		case .album: return "photo.on.rectangle"
		case .document: return "folder"
		case .scan: return "doc.text.viewfinder"
		case .clipboard: return "doc.on.clipboard"
		}
	}

	public var name: String {
		switch self {
		case .camera: return "Camera"
		case .album: return "Album"
		case .document: return "Document"
		case .scan: return "Document Scan"
		case .clipboard: return "Clipboard"
		}
	}

	public var id: Int { ImportType.allCases.firstIndex(of: self) ?? 0 }
}

public struct ImportEvent: Event {
	public let type: ImportType
	
	public init(type: ImportType) {
		self.type = type
	}
}
