//
//  EnvironmentKeys.swift
//  SharedUI
//
//  Created by Emilio Peláez on 30/03/22.
//

import Shared
import SwiftUI

struct BiometricsStateKey: EnvironmentKey {
	static var defaultValue = BiometricsState.touchID
}

struct SettingsMaxAttemptsKey: EnvironmentKey {
	static let defaultValue = 5
}

struct SettingsBiometricsKey: EnvironmentKey {
	static let defaultValue = true
}

struct SettingsColumnsKey: EnvironmentKey {
	static let defaultValue = 3
}

struct SettingsSortKey: EnvironmentKey {
	static let defaultValue = SortMethod.chronologicalDescending
}

struct SettingsShowDetailsKey: EnvironmentKey {
	static let defaultValue = false
}

struct SettingsSoundsKey: EnvironmentKey {
	static let defaultValue = true
}

struct SettingsHapticFeedbackKey: EnvironmentKey {
	static let defaultValue = true
}

public extension EnvironmentValues {

	var biometricsState: BiometricsState {
		get { self[BiometricsStateKey.self] }
		set { self[BiometricsStateKey.self] = newValue }
	}
	
	var settingsMaxAttempts: Int {
		get { self[SettingsMaxAttemptsKey.self] }
		set { self[SettingsMaxAttemptsKey.self] = newValue }
	}
	
	var settingsBiometrics: Bool {
		get { self[SettingsBiometricsKey.self] }
		set { self[SettingsBiometricsKey.self] = newValue }
	}
	
	var settingsColumns: Int {
		get { self[SettingsColumnsKey.self] }
		set { self[SettingsColumnsKey.self] = newValue }
	}

	var settingsSort: SortMethod {
		get { self[SettingsSortKey.self] }
		set { self[SettingsSortKey.self] = newValue }
	}

	var settingsShowDetails: Bool {
		get { self[SettingsShowDetailsKey.self] }
		set { self[SettingsShowDetailsKey.self] = newValue }
	}

	var settingsSound: Bool {
		get { self[SettingsSoundsKey.self] }
		set { self[SettingsSoundsKey.self] = newValue }
	}

	var settingsHapticFeedback: Bool {
		get { self[SettingsHapticFeedbackKey.self] }
		set { self[SettingsHapticFeedbackKey.self] = newValue }
	}
	
}
