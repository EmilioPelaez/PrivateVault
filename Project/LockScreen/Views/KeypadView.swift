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
	@Environment(\.biometricsState) var biometricState
	@Environment(\.settingsBiometrics) var settingsBiometrics
	
	public init() {}
	
	var columns: [GridItem] {
		Array(repeating: GridItem(.flexible(), spacing: .paddingSmall), count: 3)
	}
	
	public var body: some View {
		LazyVGrid(columns: columns, alignment: .center, spacing: .paddingSmall) {
			ForEach(1 ..< 10) {
				button(for: $0)
			}
			KeyButton(event: BiometricsRequestEvent(), opacity: .disabledAlpha) {
				Image(systemName: biometricState.imageName)
			}
			.tint(.green)
			.opacity(biometricState.available && settingsBiometrics ? 1 : 0)
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
