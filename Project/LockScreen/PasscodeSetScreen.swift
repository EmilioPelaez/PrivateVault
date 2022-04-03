//
//  PasscodeSetScreen.swift
//  LockScreen
//
//  Created by Emilio Peláez on 03/04/22.
//

import SharedUI
import SwiftUI

public struct PasscodeSetScreen: View {
	
	public init() {}
	
	public var body: some View {
		ZStack {
			Color.systemBackground
			VStack(spacing: .paddingMedium) {
				PasscodeSetHeader()
				InputDisplay()
				KeypadView()
			}
			.frame(maxWidth: .keypadMaxWidth)
		}
		.passcodeSetResponder()
	}
}

struct PasscodeSetScreen_Previews: PreviewProvider {
	static var previews: some View {
		PasscodeSetScreen()
	}
}
