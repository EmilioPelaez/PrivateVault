//
//  SetPasscodeView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 21/2/21.
//

import SwiftUI

struct SetPasscodeView: View {
	@State var code: String = ""
	@State var codeLength: Int = 4
	let newCode: (String, Int) -> Void
	
	var body: some View {
		ZStack {
			Color(.systemBackground)
			VStack(spacing: 25) {
				VStack(spacing: 10) {
					Text("Create your Passcode")
						.font(.title)
					Picker(selection: $codeLength, label: Text("")) {
						Text("4 Digits").tag(4)
						Text("6 Digits").tag(6)
					}
					.pickerStyle(SegmentedPickerStyle())
				}
				InputDisplay(input: $code, codeLength: codeLength, textColor: .primary)
				KeypadView(input: input, delete: delete)
			}
			.frame(maxWidth: 280)
		}
		.onChange(of: codeLength) { code = String(code.prefix($0)) }
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
