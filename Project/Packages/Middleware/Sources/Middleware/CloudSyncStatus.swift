//
//  CloudSyncStatus.swift
//  Middleware
//
//  Created by Emilio Peláez on 5/10/26.
//

import SwiftUI

public enum CloudSyncStatus: Hashable {
	case unknown
	case syncing
	case synced
	case error(String)
}

public extension EnvironmentValues {
	@Entry var cloudSyncStatus: CloudSyncStatus = .unknown
}
