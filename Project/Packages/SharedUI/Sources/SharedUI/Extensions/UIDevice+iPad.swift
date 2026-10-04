//
//  UIDevice+iPad.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import UIKit

public extension UIDevice {
	var isiPad: Bool { userInterfaceIdiom == .pad }
	var supportsHapticFeedback: Bool { !isiPad }
}
