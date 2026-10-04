//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import Persistence
import SwiftUI

public class UserSettings: ObservableObject {
	@Published public var maxAttempts = UserDefaults.standard.object(forKey: .maxAttempts) as? Int ?? 5 {
		didSet { UserDefaults.standard.set(maxAttempts, forKey: .maxAttempts) }
	}
	
	@Published public var biometrics = UserDefaults.standard.object(forKey: .biometrics) as? Bool ?? true {
		didSet { UserDefaults.standard.set(biometrics, forKey: .biometrics) }
	}
	
	@Published public var columns = UserDefaults.standard.object(forKey: .columns) as? Int ?? 3 {
		didSet { UserDefaults.standard.set(columns, forKey: .columns) }
	}
	
	@Published public var sort = SortMethod(rawValue: UserDefaults.standard.integer(forKey: .sort)) ?? .chronologicalDescending {
		didSet { UserDefaults.standard.set(sort.rawValue, forKey: .sort) }
	}
	
	@Published public var showDetails = UserDefaults.standard.bool(forKey: .showDetails) {
		didSet { UserDefaults.standard.set(showDetails, forKey: .showDetails) }
	}
	
	@Published public var sound = UserDefaults.standard.object(forKey: .sound) as? Bool ?? true {
		didSet { UserDefaults.standard.set(sound, forKey: .sound) }
	}
	
	@Published public var hapticFeedback = UserDefaults.standard.object(forKey: .hapticFeedback) as? Bool ?? true {
		didSet { UserDefaults.standard.set(hapticFeedback, forKey: .hapticFeedback) }
	}
	
	//	Ignored for now
	@Published public var contentMode: ContentMode = .fit
	
	public init(demo: Bool = false) {
		guard demo else { return }
		showDetails = true
		columns = 3
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
