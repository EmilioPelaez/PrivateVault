//
//  PersistenceModifier.swift
//  Persistence
//
//  Created by Emilio Peláez on 5/10/26.
//

import CloudKit
import Combine
import SwiftUI

public extension EnvironmentValues {
	@Entry var iCloudEnabled: Bool = false
}

struct PersistenceModifier: ViewModifier {
	@StateObject private var manager: PersistenceManager
	@State private var iCloudEnabled: Bool
	
	private let usesCloud: Bool
	private let accountChanges = NotificationCenter.default
		.publisher(for: .CKAccountChanged)
		.receive(on: DispatchQueue.main)
	
	init(usage: PersistenceManager.Usage) {
		let usesCloud = usage == .main
		self._manager = StateObject(wrappedValue: PersistenceManager(usage: usage))
		self.usesCloud = usesCloud
		self._iCloudEnabled = State(initialValue: usesCloud)
	}
	
	func body(content: Content) -> some View {
		content
			.environment(\.managedObjectContext, manager.context)
			.environmentObject(manager)
			.environment(\.iCloudEnabled, iCloudEnabled)
			.task { await checkAccount() }
			.onReceive(accountChanges) { _ in
				Task { await checkAccount() }
			}
	}
	
	@MainActor
	private func checkAccount() async {
		guard usesCloud else { return }
		let container = CKContainer(identifier: PersistenceManager.cloudKitIdentifier)
		guard let status = try? await container.accountStatus() else { return }
		iCloudEnabled = status == .available
	}
}

public extension View {
	func persistence(_ usage: PersistenceManager.Usage) -> some View {
		modifier(PersistenceModifier(usage: usage))
	}
}
