//
//  FeedbackGenerator.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import AudioToolbox
import UIKit

class FeedbackGenerator {
	
	static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
		if UIDevice.supportsHapticFeedback {
			UIImpactFeedbackGenerator(style: style).impactOccurred()
		} else {
			AudioServicesPlaySystemSound(SystemSoundID(UInt32(1104)))
		}
	}
	
}
