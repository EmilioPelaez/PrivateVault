//
//  PasscodeManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 11/3/21.
//

import KeychainAccess
import SwiftUI

class PasscodeManager: ObservableObject {
	
	private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "Private Vault")
//		.synchronizable(true) // this might be causing a crash
	
	@Published
	var passcodeSet: Bool = false
	
	init() {
		updatePasscodeSet()
	}
	
	private let passcodeKey = "passcode"
	var passcode: String {
		get { keychain[passcodeKey] ?? "" }
		set {
			keychain[passcodeKey] = newValue
			passcodeSet = passcode.count == passcodeLength
		}
	}
	
	private let passcodeLengthKey = "passcodeLength"
	var passcodeLength: Int {
		get { keychain[data: passcodeLengthKey]?.withUnsafeBytes { $0.load(as: Int.self) } ?? 6 }
		set {
			withUnsafeBytes(of: newValue) { keychain[data: passcodeLengthKey] = Data($0) }
			updatePasscodeSet()
		}
	}
	
	private func updatePasscodeSet() {
		passcodeSet = passcode.count == passcodeLength
	}
	
}
