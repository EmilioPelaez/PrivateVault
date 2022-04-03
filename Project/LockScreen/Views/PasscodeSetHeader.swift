//
//  PasscodeSetHeader.swift
//  LockScreen
//
//  Created by Emilio Peláez on 03/04/22.
//

import HierarchyResponder
import SwiftUI

struct PasscodeSetHeader: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	@Environment(\.passcodeConfirming) var passcodeConfirming
	
	@State var length = 6
	
	var body: some View {
		VStack(spacing: .paddingMedium) {
			if passcodeConfirming {
				Text("Confirm Passcode")
					.font(.title)
			} else {
				Text("Create your Passcode")
					.font(.title)
			}
			Picker(selection: $length, label: Text("")) {
				Text("4 Digits").tag(4)
				Text("6 Digits").tag(6)
			}
			.pickerStyle(SegmentedPickerStyle())
			.opacity(passcodeConfirming ? 0 : 1)
		}
		.onChange(of: length) {
			triggerEvent(PasscodeLengthSetEvent(length: $0))
		}
	}
}

struct PasscodeSetHeader_Previews: PreviewProvider {
	static var previews: some View {
		PasscodeSetHeader()
			.preparePreview()
	}
}
