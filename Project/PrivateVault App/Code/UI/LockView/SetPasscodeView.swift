//
//  SetPasscodeView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

struct SetPasscodeView: View {
	@State var code: String = ""
	@State var codeLengthIndex: Int = 0
	@State var codeLength: Int = 4
	let newCode: (String, Int) -> Void
	
	var body: some View {
		ZStack {
			Color(.systemBackground)
			VStack(spacing: 25) {
				VStack(spacing: 10) {
					Text("Create your Passcode")
						.font(.title)
					Picker(selection: $codeLengthIndex, label: Text("")) {
						Text("4 Digits").tag(0)
						Text("6 Digits").tag(1)
					}
					.pickerStyle(SegmentedPickerStyle())
				}
				InputDisplay(input: $code, codeLength: codeLength, textColor: .primary, displayColor: nil)
				KeypadView(input: input, delete: delete) { Spacer() }
			}
			.frame(maxWidth: 280)
		}
		.onChange(of: codeLengthIndex) { index in
			withAnimation {
				codeLength = [4, 6][index]
				code = String(code.prefix(max(0, codeLength - 1)))
			}
		}
	}
	
	func input(_ string: String) {
		guard code.count < codeLength else { return }
		code.append(string)
		if code.count == codeLength {
			newCode(code, codeLength)
		}
	}
	
	func delete() {
		guard !code.isEmpty else { return }
		code.removeLast()
	}
	
}

struct SetPasscodeView_Previews: PreviewProvider {
	static var previews: some View {
		SetPasscodeView(code: "01") { _, _ in }
		
		SetPasscodeView(code: "012", codeLength: 6) { _, _ in }
	}
}
