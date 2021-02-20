//
//  UIDevice+iPad.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import UIKit

extension UIDevice {
	static var isiPad: Bool { current.userInterfaceIdiom == .pad }
	static var supportsHapticFeedback: Bool { !isiPad }
}
