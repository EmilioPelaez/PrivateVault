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

struct PasscodeStateKey: EnvironmentKey {
	static var defaultValue = PasscodeState.undefined
}

struct PasscodeEnteredKey: EnvironmentKey {
	static var defaultValue = ""
}

struct PasscodeLengthKey: EnvironmentKey {
	static var defaultValue = 4
}

extension EnvironmentValues {
	var passcodeState: PasscodeState {
		get { self[PasscodeStateKey.self] }
		set { self[PasscodeStateKey.self] = newValue }
	}
	
	var passcodeEntered: String {
		get { self[PasscodeEnteredKey.self] }
		set { self[PasscodeEnteredKey.self] = newValue }
	}
	
	var passcodeLength: Int {
		get { self[PasscodeLengthKey.self] }
		set { self[PasscodeLengthKey.self] = newValue }
	}
}
