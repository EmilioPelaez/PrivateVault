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
	@State private var showError = false
	
	var body: some View {
		if let errorMessage {
			Button {
				showError = true
			} label: {
				content
					.contentShape(Rectangle())
			}
			.buttonStyle(.plain)
			.alert("Sync Error", isPresented: $showError) {
				Button("Ok") {}
			} message: {
				Text(errorMessage)
			}
		} else {
			content
		}
	}
	
	private var content: some View {
		LabeledContent("Sync Status") {
			HStack(spacing: 6) {
				Circle()
					.fill(color)
					.frame(width: 8, height: 8)
				Text(title)
				if errorMessage != nil {
					Image(systemName: "info.circle")
				}
			}
		}
	}
	
	private var errorMessage: String? {
		guard case let .error(message) = status else { return nil }
		return message
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
