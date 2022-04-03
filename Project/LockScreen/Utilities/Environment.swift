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

struct PasscodeSetKey: EnvironmentKey {
	static var defaultValue = false
}

struct AppLockedKey: EnvironmentKey {
	static var defaultValue = true
}

public extension EnvironmentValues {
	var passcodeSet: Bool {
		get { self[PasscodeSetKey.self] }
		set { self[PasscodeSetKey.self] = newValue }
	}
	
	var appLocked: Bool {
		get { self[AppLockedKey.self] }
		set { self[AppLockedKey.self] = newValue }
	}
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

struct PasscodeMaxAttemptsKey: EnvironmentKey {
	static var defaultValue = 5
}

struct PasscodeAttemptsRemainingKey: EnvironmentKey {
	static var defaultValue = 5
}

struct PasscodeLockedOutKey: EnvironmentKey {
	static var defaultValue = false
}

struct PasscodeLockedOutDateKey: EnvironmentKey {
	static var defaultValue: Date? = nil
}

struct PasscodeConfirmingKey: EnvironmentKey {
	static var defaultValue = false
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
	
	var passcodeAttemptsRemaining: Int {
		get { self[PasscodeAttemptsRemainingKey.self] }
		set { self[PasscodeAttemptsRemainingKey.self] = newValue }
	}
	
	var passcodeLockedOut: Bool {
		get { self[PasscodeLockedOutKey.self] }
		set { self[PasscodeLockedOutKey.self] = newValue }
	}
	
	var passcodeLockedOutDate: Date? {
		get { self[PasscodeLockedOutDateKey.self] }
		set { self[PasscodeLockedOutDateKey.self] = newValue }
	}
	
	var passcodeConfirming: Bool {
		get { self[PasscodeConfirmingKey.self] }
		set { self[PasscodeConfirmingKey.self] = newValue }
	}
}
