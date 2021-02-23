//
//  SetPasscodeView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

struct SetPasscodeView: View {
	@State var code: String = ""
	@State var enteredCode: String = ""
	@State var codeLengthIndex: Int = 0
	@State var codeLength: Int = 4
	let newCode: (String, Int) -> Void
	
	var body: some View {
		ZStack {
			Color(.systemBackground)
			VStack(spacing: 25) {
				VStack(spacing: 10) {
					if enteredCode.isEmpty {
						VStack {
							Text("Create your Passcode")
								.font(.title)
							Picker(selection: $codeLengthIndex, label: Text("")) {
								Text("4 Digits").tag(0)
								Text("6 Digits").tag(1)
							}
							.pickerStyle(SegmentedPickerStyle())
						}
						.transition(.opacity.combined(with: .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))))
					} else {
						Text("Confirm your Passcode")
							.font(.title)
							.transition(.opacity.combined(with: .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))))
					}
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
		guard code.count == codeLength else { return }
		if enteredCode.isEmpty {
			withAnimation {
				enteredCode = code
				code = ""
			}
		} else if enteredCode == code {
			newCode(code, codeLength)
		} else {
			withAnimation {
				enteredCode = ""
				code = ""
			}
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
