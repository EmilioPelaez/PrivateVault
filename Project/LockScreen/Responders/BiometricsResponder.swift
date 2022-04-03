//
//  BiometricsResponder.swift
//  LockScreen
//
//  Created by Emilio Peláez on 02/04/22.
//

import HierarchyResponder
import LocalAuthentication
import Shared
import SharedUI
import SwiftUI

struct BiometricsRequestEvent: Event {}
struct BiometricsSuccessEvent: Event {}
struct BiometricsFailureError: Error {
	let underlying: Error?
}

extension View {
	func biometricsResponder(reason: String = "Biometrics access required to unlock application") -> some View {
		modifier(BiometricsResponder(reason: reason))
	}
}

struct BiometricsResponder: ViewModifier {
	@Environment(\.triggerEvent) var triggerEvent
	@Environment(\.reportError) var reportError
	
	let biometricsContext = LAContext()
	@State var biometricsState = BiometricsState.none
	
	let reason: String
	
	func body(content: Content) -> some View {
		content
			.onAppear(perform: updateBiometricsState)
			.handleEvent(BiometricsRequestEvent.self, handler: performBiometricsAuthorization)
			.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in updateBiometricsState() }
			.environment(\.biometricsState, biometricsState)
	}
	
	func updateBiometricsState() {
		switch biometricsContext.availableType {
		case .faceID: biometricsState = .faceID
		case .touchID: biometricsState = .touchID
		case _: biometricsState = .none
		}
	}
	
	func performBiometricsAuthorization() {
		biometricsContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
			DispatchQueue.main.async {
				guard success else {
					return reportError(BiometricsFailureError(underlying: error))
				}
				triggerEvent(BiometricsSuccessEvent())
			}
		}
	}
}
