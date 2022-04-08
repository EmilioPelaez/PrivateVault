//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import Shared
import SwiftUI

class UserSettings: ObservableObject {
	@Published var maxAttempts = UserDefaults.standard.object(forKey: .maxAttempts) as? Int ?? 5 {
		didSet { UserDefaults.standard.set(maxAttempts, forKey: .maxAttempts) }
	}
	
	@Published var biometrics = UserDefaults.standard.object(forKey: .biometrics) as? Bool ?? true {
		didSet { UserDefaults.standard.set(biometrics, forKey: .biometrics) }
	}
	
	@Published var columns = UserDefaults.standard.object(forKey: .columns) as? Int ?? 3 {
		didSet { UserDefaults.standard.set(columns, forKey: .columns) }
	}
	
	@Published var sort = SortMethod(rawValue: UserDefaults.standard.integer(forKey: .sort)) ?? .chronologicalDescending {
		didSet { UserDefaults.standard.set(sort.rawValue, forKey: .sort) }
	}
	
	@Published var showDetails = UserDefaults.standard.bool(forKey: .showDetails) {
		didSet { UserDefaults.standard.set(showDetails, forKey: .showDetails) }
	}
	
	@Published var sound = UserDefaults.standard.object(forKey: .sound) as? Bool ?? true {
		didSet { UserDefaults.standard.set(sound, forKey: .sound) }
	}
	
	@Published var hapticFeedback = UserDefaults.standard.object(forKey: .hapticFeedback) as? Bool ?? true {
		didSet { UserDefaults.standard.set(hapticFeedback, forKey: .hapticFeedback) }
	}
	
	//	Ignored for now
	@Published var contentMode: ContentMode = .fit
	
	init(demo: Bool = false) {
		guard demo else { return }
		self.showDetails = true
		self.columns = 3
	}
}

private extension String {
	static let biometrics = "biometrics"
	static let maxAttempts = "maxAttempts"
	static let columns = "columns"
	static let sort = "sort"
	static let showDetails = "showDetails"
	static let sound = "sound"
	static let hapticFeedback = "hapticFeedback"
}
