//
//  LockScreen.swift
//  LockScreen
//
//  Created by Emilio Peláez on 30/03/22.
//

import HierarchyResponder
import SharedUI
import SwiftUI

public struct LockScreen: View {
	@State var input: String = ""
	
	public init() {}
	
	public var body: some View {
		ZStack {
			Color.systemBackground
			VStack(spacing: .paddingMedium) {
				InputDisplay(input: input, codeLength: 4)
				KeypadView()
			}
			.frame(maxWidth: .keypadMaxWidth)
		}
		.lockScreenResponder(input: $input)
	}
}

struct LockScreen_Previews: PreviewProvider {
	static var previews: some View {
		LockScreen()
	}
}
