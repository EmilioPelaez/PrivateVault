//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

final class UserSettings: ObservableObject {
	@Published var maxAttempts = UserDefaults.standard.object(forKey: .maxAttempts) as? Int ?? 5 {
		didSet { UserDefaults.standard.set(maxAttempts, forKey: .maxAttempts) }
	}
	@Published var biometrics = UserDefaults.standard.object(forKey: .biometrics) as? Bool ?? true {
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
	@Published var contentMode: ContentMode = .fit
}

fileprivate extension String {
	static let codeLength = "codeLength"
	static let biometrics = "biometrics"
	static let maxAttempts = "maxAttempts"
	static let columns = "columns"
	static let showDetailsKey = "showDetailsKey"
	static let sound = "sound"
	static let hapticFeedback = "hapticFeedback"
}
