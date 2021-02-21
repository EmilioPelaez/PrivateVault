//
//  PersistenceEnvironment.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

struct PersistenceControllerEnvironmentKey: EnvironmentKey {
	static let defaultValue: PersistenceController? = nil
}

extension EnvironmentValues {
	var persistenceController: PersistenceController? {
		get {
			return self[PersistenceControllerEnvironmentKey]
		}
		set {
			self[PersistenceControllerEnvironmentKey] = newValue
		}
	}
}
