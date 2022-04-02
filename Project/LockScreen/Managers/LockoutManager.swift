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
	
	@Published var unlockDate: Date?
	@Published var isLockedOut: Bool
	
	var timerToken: Cancellable?
	
	private let unlockDateKey = "unlockDateKey"
	private let keychain = Keychain()
	
	init() {
		let interval = keychain[data: unlockDateKey]?.withUnsafeBytes { $0.load(as: Double.self) } as TimeInterval?
		let unlockDate = interval.map { Date(timeIntervalSinceReferenceDate: $0) }
		self.unlockDate = unlockDate
		if unlockDate ?? .distantPast > Date() {
			self.isLockedOut = true
			createTimer()
		} else {
			self.isLockedOut = false
		}
		
	}
	
	func lockout() {
		let unlockDate = Date().addingTimeInterval(60 * 60 * 6 - 1)
		var interval = unlockDate.timeIntervalSinceReferenceDate
		withUnsafeBytes(of: &interval) { keychain[data: unlockDateKey] = Data($0) }
		self.unlockDate = unlockDate
		isLockedOut = true
		createTimer()
	}
	
	private func createTimer() {
		stopTimer()
		timerToken = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in self?.tick() }
	}
	
	private func tick() {
		guard let unlockDate = unlockDate else {
			return stopTimer()
		}
		guard Date() > unlockDate else { return }
		isLockedOut = false
		print(#function)
		stopTimer()
	}
	
	private func stopTimer() {
		timerToken?.cancel()
		timerToken = nil
	}
	
}
