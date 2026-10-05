//
//  CloudSyncStatusProvider.swift
//  Middleware
//
//  Created by Emilio Peláez on 5/10/26.
//

import Combine
import CoreData
import SwiftUI

struct CloudSyncStatusProvider: ViewModifier {
	@State private var status: CloudSyncStatus = .unknown
	@State private var activeEvents: Set<UUID> = []
	
	private let events = NotificationCenter.default
		.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
		.compactMap { $0.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event }
		.receive(on: DispatchQueue.main)
	
	func body(content: Content) -> some View {
		content
			.environment(\.cloudSyncStatus, status)
			.onReceive(events, perform: handle)
	}
	
	private func handle(_ event: NSPersistentCloudKitContainer.Event) {
		guard event.endDate != nil else {
			activeEvents.insert(event.identifier)
			status = .syncing
			return
		}
		activeEvents.remove(event.identifier)
		if event.error != nil {
			status = .error
		} else if activeEvents.isEmpty {
			status = .synced
		}
	}
}

public extension View {
	func cloudSyncStatusProvider() -> some View {
		modifier(CloudSyncStatusProvider())
	}
}
