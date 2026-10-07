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
	@State private var showDetails = false
	
	var body: some View {
		Button {
			showDetails = true
		} label: {
			LabeledContent("Sync Status") {
				HStack(spacing: 6) {
					Circle()
						.fill(color)
						.frame(width: 8, height: 8)
					Text(title)
				}
				.foregroundStyle(.secondary)
			}
		}
		.foregroundStyle(.primary)
		.alert(alertTitle, isPresented: $showDetails) {
			Button("Ok") {}
		} message: {
			Text(message)
		}
	}
	
	private var alertTitle: String {
		if case .error = status { return "Sync Error" }
		return "iCloud Sync"
	}
	
	private var message: String {
		switch status {
		case .unknown where iCloudEnabled: "No sync activity has been reported yet. Your vault syncs with iCloud automatically."
		case .unknown: "iCloud isn't available on this device. Sign in to iCloud in Settings to sync your vault."
		case .syncing: "Your vault is syncing with iCloud."
		case .synced: "Your vault is up to date with iCloud."
		case let .error(message): message
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
		ForEach([CloudSyncStatus.unknown, .syncing, .synced, .error("The request couldn't be completed, your iCloud storage is full.")], id: \.self) {
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
