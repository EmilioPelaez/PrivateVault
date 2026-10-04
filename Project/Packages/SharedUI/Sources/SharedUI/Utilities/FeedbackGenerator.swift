//
//  FeedbackGenerator.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import AudioToolbox
import ToolKit
import UIKit

public class FeedbackGenerator {
	public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
		if Platform.current != .pad {
			UIImpactFeedbackGenerator(style: style).impactOccurred()
		} else {
			// swiftlint:disable:next number_separator
			AudioServicesPlaySystemSound(SystemSoundID(UInt32(1104)))
		}
	}
}
