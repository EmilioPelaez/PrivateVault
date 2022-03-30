//
//  Environment.swift
//  LockScreen
//
//  Created by Emilio Peláez on 31/03/22.
//

import SwiftUI

enum PasscodeState {
	case undefined
	case correct
	case incorrect
}

struct PasscodeStateEnvironmentKey: EnvironmentKey {
	static var defaultValue = PasscodeState.undefined
}

extension EnvironmentValues {
	var passcodeState: PasscodeState {
		get { self[PasscodeStateEnvironmentKey.self] }
		set { self[PasscodeStateEnvironmentKey.self] = newValue }
	}
}
