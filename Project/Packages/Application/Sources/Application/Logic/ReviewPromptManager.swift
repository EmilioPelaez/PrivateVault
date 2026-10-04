//
//  ReviewPromptManager.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 24/10/21.
//

import StoreKit
import UIKit

class ReviewPromptManager {
	
	private let triggerCountKey = "Review Trigger Count"
	
	private let windowScene: UIWindowScene
	
	private var triggerCount: Int {
		didSet { UserDefaults.standard.set(triggerCount, forKey: triggerCountKey) }
	}

	private let maxTriggerCount = 4
	
	init?() {
		let scene = UIApplication.shared
			.connectedScenes
			.filter { $0.activationState == .foregroundActive }
			.compactMap { $0 as? UIWindowScene }
			.first
		guard let windowScene = scene else {
			assertionFailure("Window Scene is nil")
			return nil
		}
		
		self.windowScene = windowScene
		self.triggerCount = UserDefaults.standard.integer(forKey: triggerCountKey)
	}
	
	func trigger() {
		triggerCount += 1
		if triggerCount % maxTriggerCount == 0 {
			SKStoreReviewController.requestReview(in: windowScene)
			triggerCount = 0
		}
	}
	
}
