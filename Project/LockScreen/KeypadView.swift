//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import HierarchyResponder
import SharedUI
import SwiftUI

public struct KeypadView: View {
	@Environment(\.biometricSymbolName) var biometricSymbolName
	
	public init() {}
	
	public var body: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: .paddingSmall), count: 3),
							alignment: .center,
							spacing: .paddingSmall) {
			ForEach(1 ..< 10) {
				button(for: $0)
			}
			KeyButton(event: BiometricUnlockEvent(), opacity: .disabledAlpha) {
				Image(systemName: biometricSymbolName)
			}
			.tint(.green)
			button(for: 0)
			KeyButton(event: KeypadDeleteEvent(), opacity: .disabledAlpha) {
				Image(systemName: "delete.left")
			}
			.tint(.red)
		}
		.tint(.primary)
		.font(.title)
	}
	
	func button(for value: Int) -> some View {
		let string = "\(value)"
		return KeyButton(event: KeyDownEvent(value: string), opacity: .backgroundAlpha) {
			Text(string)
		}
	}
}


struct KeypadView_Previews: PreviewProvider {
	static var previews: some View {
		KeypadView()
			.frame(width: 250)
			.preparePreview()
			.previewFontSizes()
			.previewColorSchemes()
	}
}
