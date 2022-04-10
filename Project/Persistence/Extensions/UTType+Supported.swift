//
//  UTType+Supported.swift
//  PrivateVault Import Action
//
//  Created by Emilio Peláez on 16/3/21.
//

import UniformTypeIdentifiers.UTType

extension UTType {
	var isSupported: Bool {
		[UTType].supportedTypes.contains { conforms(to: $0) }
	}
}

extension Array where Element == UTType {
	static var supportedTypes: [Element] {
		[.image, .audiovisualContent, .pdf, .text]
	}
}
