//
//  EnvironmentKeys.swift
//  SharedUI
//
//  Created by Emilio Peláez on 30/03/22.
//

import SwiftUI

struct BiometricSymbolEnvironmentKey: EnvironmentKey {
	static var defaultValue = "faceid"
}

public extension EnvironmentValues {
	var biometricSymbolName: String {
		get { self[BiometricSymbolEnvironmentKey.self] }
		set { self[BiometricSymbolEnvironmentKey.self] = newValue }
	}
}
