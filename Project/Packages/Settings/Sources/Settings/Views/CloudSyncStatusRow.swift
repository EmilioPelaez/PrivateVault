//
//  CloudSyncStatusRow.swift
//  Settings
//
//  Created by Emilio Peláez on 5/10/26.
//

import Middleware
import Persistence
import SwiftUI

struct CloudSyncStatusRow: View {
	@Environment(\.iCloudEnabled) private var iCloudEnabled
	@Environment(\.cloudSyncStatus) private var status
	
	var body: some View {
		LabeledContent("Sync Status") {
			HStack(spacing: 6) {
				Circle()
					.fill(color)
					.frame(width: 8, height: 8)
				Text(title)
			}
		}
	}
	
	private var title: String {
		switch status {
		case .unknown: iCloudEnabled ? "Unknown" : "Unavailable"
		case .syncing: "Syncing"
		case .synced: "Synced"
		case .error: "Error"
		}
	}
	
	private var color: Color {
		switch status {
		case .unknown: .gray
		case .syncing: .yellow
		case .synced: .green
		case .error: .red
		}
	}
}

#Preview {
	Form {
		ForEach([CloudSyncStatus.unknown, .syncing, .synced, .error], id: \.self) {
			CloudSyncStatusRow()
				.environment(\.cloudSyncStatus, $0)
				.environment(\.iCloudEnabled, true)
		}
		CloudSyncStatusRow()
			.environment(\.cloudSyncStatus, .unknown)
			.environment(\.iCloudEnabled, false)
		CloudSyncStatusRow()
			.environment(\.cloudSyncStatus, .synced)
			.environment(\.iCloudEnabled, false)
	}
}
