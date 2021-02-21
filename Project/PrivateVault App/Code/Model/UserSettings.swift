//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

final class UserSettings: ObservableObject {
	//	TODO: Move this out of UserDefaults and into CoreData
	@AppStorage("passcode") var passcode = ""
	@AppStorage("codeLength") var codeLength =  4
	@AppStorage("maxAttempts") var maxAttempts = 5
	@AppStorage("columns") var columns = 3
	@AppStorage("showDetails") var showDetails = true
	@AppStorage("sound") var sound = true
	@AppStorage("hapticFeedback") var hapticFeedback = true

	//	Ignored for now
	@Published var contentMode: ContentMode = .fill
}

fileprivate extension String {
	static let passcode = "passcode"
	static let codeLength = "codeLength"
	static let maxAttempts = "maxAttempts"
	static let columns = "columns"
	static let showDetailsKey = "showDetailsKey"
	static let sound = "sound"
	static let hapticFeedback = "hapticFeedback"
}
