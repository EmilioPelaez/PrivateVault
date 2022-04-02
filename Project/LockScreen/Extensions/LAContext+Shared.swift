//
//  LAContext+Shared.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import LocalAuthentication

extension LAContext {
	var availableType: LABiometryType {
		var error: NSError?

		guard canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
			return .none
		}

		switch biometryType {
		case .none: return .none
		case .touchID: return .touchID
		case .faceID: return .faceID
		case _: return .none
		}
	}
}
