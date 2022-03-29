//
//  LockoutManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 15/3/21.
//

import Combine
import KeychainAccess
import SwiftUI

class LockoutManager: ObservableObject {
	
	var unlockDate: Date?
	@Published var update = true
	var bag: Set<AnyCancellable> = []
	
	var isLockedOut: Bool {
		unlockDate ?? .distantPast > Date()
	}
	
	private let unlockDateKey = "unlockDateKey"
	private let keychain = Keychain()
	
	init() {
		let interval = keychain[data: unlockDateKey]?.withUnsafeBytes { $0.load(as: Double.self) } as TimeInterval?
		self.unlockDate = interval.map { Date(timeIntervalSinceReferenceDate: $0) }
		guard unlockDate ?? .distantPast > Date() else { return }
		createTimer()
	}
	
	func lockout() {
		let unlockDate = Date().addingTimeInterval(60 * 60 * 6 - 1)
		var interval = unlockDate.timeIntervalSinceReferenceDate
		withUnsafeBytes(of: &interval) { keychain[data: unlockDateKey] = Data($0) }
		self.unlockDate = unlockDate
		createTimer()
	}
	
	private func createTimer() {
		stopTimer()
		Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in self?.tick() }
			.store(in: &bag)
	}
	
	private func tick() {
		guard let unlockDate = unlockDate else { return }
		defer {
			withAnimation { update.toggle() }
		}
		guard Date() > unlockDate else { return }
		stopTimer()
	}
	
	private func stopTimer() {
		bag.forEach { $0.cancel() }
		bag = []
	}
	
}
