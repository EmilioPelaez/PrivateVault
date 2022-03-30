//
//  Constants.swift
//  UISupport
//
//  Created by Emilio Peláez on 14/11/21.
//

import SwiftUI

public extension CGFloat {
	static let contentWidth: CGFloat = 550
	
	static let paddingSmall: CGFloat = 4
	static let paddingMedium: CGFloat = 8
	static let paddingLarge: CGFloat = 16
	static let paddingExtra: CGFloat = 32
	
	static let disabledAlpha: CGFloat = 0.25
	static let secondaryAlpha: CGFloat = 0.7
	static let backgroundAlpha: CGFloat = 0.05
	
	static let keypadMaxWidth: CGFloat = 280
	
	static let macSidebarMinWidth: CGFloat = 200
	static let macWindowMinWidth = macSidebarMinWidth + paddingLarge + contentWidth + paddingLarge
	static let macWindowMinHeight: CGFloat = 600
	
	static let macPopoverWidth: CGFloat = 400
	static let macPopoverHeight: CGFloat = 500
}

public extension Double {
	static let disabledAlpha: CGFloat = 0.25
	static let secondaryAlpha: CGFloat = 0.7
	static let backgroundAlpha: CGFloat = 0.05
}
