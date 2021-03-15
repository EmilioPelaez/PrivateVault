//
//  LockoutManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 15/3/21.
//

import Combine
import SwiftUI

class LockoutManager: ObservableObject {
	
	var unlockDate: Date?
	@Published var update = true
	var bag: Set<AnyCancellable> = []
	
	var isLockedOut: Bool {
		unlockDate ?? .distantPast > Date()
	}
	
	init() {
		
	}
	
	func lockout() {
		unlockDate = Date().addingTimeInterval(60 * 60 * 6)
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
