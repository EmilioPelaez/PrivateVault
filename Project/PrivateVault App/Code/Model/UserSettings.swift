//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

final class UserSettings: ObservableObject {
	@Published var passcode = UserDefaults.standard.object(forKey: .passcode) as? String ?? "" {
		didSet { UserDefaults.standard.set(passcode, forKey: .passcode) }
	}
	@Published var codeLength = UserDefaults.standard.object(forKey: .codeLength) as? Int ?? 4 {
		didSet { UserDefaults.standard.set(codeLength, forKey: .codeLength) }
	}
	@Published var maxAttempts = UserDefaults.standard.object(forKey: .maxAttempts) as? Int ?? 5 {
		didSet { UserDefaults.standard.set(maxAttempts, forKey: .maxAttempts) }
	}
	@Published var biometrics = UserDefaults.standard.bool(forKey: .biometrics) {
		didSet { UserDefaults.standard.set(biometrics, forKey: .biometrics) }
	}
	@Published var columns = UserDefaults.standard.object(forKey: .columns) as? Int ?? 3 {
		didSet { UserDefaults.standard.set(columns, forKey: .columns) }
	}
	@Published var showDetails = UserDefaults.standard.bool(forKey: .showDetailsKey) {
		didSet { UserDefaults.standard.set(showDetails, forKey: .showDetailsKey) }
	}
	@Published var sound = UserDefaults.standard.object(forKey: .sound) as? Bool ?? true {
		didSet { UserDefaults.standard.set(sound, forKey: .sound) }
	}
	@Published var hapticFeedback = UserDefaults.standard.object(forKey: .hapticFeedback) as? Bool ?? true {
		didSet { UserDefaults.standard.set(hapticFeedback, forKey: .hapticFeedback) }
	}

	//	Ignored for now
	@Published var contentMode: ContentMode = .fill
}

fileprivate extension String {
	static let passcode = "passcode"
	static let codeLength = "codeLength"
	static let biometrics = "biometrics"
	static let maxAttempts = "maxAttempts"
	static let columns = "columns"
	static let showDetailsKey = "showDetailsKey"
	static let sound = "sound"
	static let hapticFeedback = "hapticFeedback"
}
