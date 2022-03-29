//
//  PasscodeManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 11/3/21.
//

import KeychainAccess
import SwiftUI

class PasscodeManager: ObservableObject {
	
	private let keychain = Keychain().synchronizable(true)
	
	@Published
	var passcodeSet: Bool = false
	
	private let passcodeKey = "passcode"
	private let passcodeLengthKey = "passcodeLength"
	init(demo: Bool = false) {
		if demo {
			self.passcode = "000000"
			self.passcodeLength = 6
		} else {
			self.passcode = keychain[passcodeKey] ?? ""
			self.passcodeLength = keychain[data: passcodeLengthKey]?.withUnsafeBytes { $0.load(as: Int.self) } ?? 6
		}
		updatePasscodeSet()
	}
	
	var passcode: String {
		didSet {
			keychain[passcodeKey] = passcode
			updatePasscodeSet()
		}
	}
	
	var passcodeLength: Int {
		didSet {
			withUnsafeBytes(of: passcodeLength) { keychain[data: passcodeLengthKey] = Data($0) }
			updatePasscodeSet()
		}
	}
	
	private func updatePasscodeSet() {
		passcodeSet = passcode.count == passcodeLength
	}
	
}
