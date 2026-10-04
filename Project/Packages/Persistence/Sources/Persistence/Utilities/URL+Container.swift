//
//  URL+Container.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 15/3/21.
//

import Foundation

public extension URL {
	static var container: URL {
		guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.emiliopelaez.Private-Vault") else {
			fatalError("Unable to get container url.")
		}
		return url
	}
}
