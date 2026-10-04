//
//  URL+Filename.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import Foundation

public extension URL {
	var filename: String {
		deletingPathExtension().lastPathComponent
	}
}
