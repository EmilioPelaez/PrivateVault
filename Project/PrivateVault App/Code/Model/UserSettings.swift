//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

final class UserSettings: ObservableObject {
	@Published var contentMode: ContentMode = .fill
	@Published var showDetails = UserDefaults.standard.bool(forKey: .showDetailsKey) {
		didSet { UserDefaults.standard.set(showDetails, forKey: .showDetailsKey) }
	}
	//	TODO: Move this out of UserDefaults and into CoreData
	@Published var passcode = UserDefaults.standard.object(forKey: .passcode) as? String ?? "" {
		didSet { UserDefaults.standard.set(passcode, forKey: .passcode) }
	}
	@Published var codeLength = UserDefaults.standard.object(forKey: .codeLength) as? Int ?? 4 {
		didSet { UserDefaults.standard.set(codeLength, forKey: .codeLength) }
	}
	@Published var maxAttempts = UserDefaults.standard.object(forKey: .maxAttempts) as? Int ?? 5 {
		didSet { UserDefaults.standard.set(maxAttempts, forKey: .maxAttempts) }
	}
}

fileprivate extension String {
	static let showDetailsKey = "showDetailsKey"
	static let passcode = "passcode"
	static let codeLength = "codeLength"
	static let maxAttempts = "maxAttempts"
}
