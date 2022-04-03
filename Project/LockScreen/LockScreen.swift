//
//  LockScreen.swift
//  LockScreen
//
//  Created by Emilio Peláez on 30/03/22.
//

import SharedUI
import SwiftUI

public struct LockScreen: View {
	
	public init() {}
	
	public var body: some View {
		ZStack {
			Color.systemBackground
			VStack(spacing: .paddingMedium) {
				AttemptsView()
				InputDisplay()
				KeypadView()
			}
			.frame(maxWidth: .keypadMaxWidth)
		}
		.biometricsResponder()
		.lockScreenResponder()
	}
}

struct LockScreen_Previews: PreviewProvider {
	static var previews: some View {
		LockScreen()
			.environmentObject(PasscodeManager())
	}
}
