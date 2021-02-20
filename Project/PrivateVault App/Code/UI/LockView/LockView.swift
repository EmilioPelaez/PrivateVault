//
//  LockView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct LockView: View {
	let password = "1234"
	@Binding var isLocked: Bool
	@State var code: String = ""
	@State var isIncorrect: Bool = false
	let maxDigits: Int = 4
	
	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()
			VStack(spacing: 25) {
				InputDisplay(codeLength: maxDigits, input: $code, textColor: textColor)
					.shake(isIncorrect, distance: 10, count: 4)
					.soundEffect(soundEffect: isIncorrect ? .failure : .none)
					.soundEffect(soundEffect: !isLocked ? .success : .none)
				KeypadView(input: input, delete: delete)
			}
			.frame(maxWidth: 280)
		}
	}

	var textColor: Color {
		guard code.count == maxDigits else { return .primary }

		return isIncorrect ? .red : .green
	}
	
	func input(_ string: String) {
		if (code.count ==  maxDigits && isIncorrect) {
			code = ""
			isIncorrect = false
		}
		guard code.count < maxDigits else { return }
		code.append(string)
		if code.count == password.count {
			withAnimation {
				if code == password {
					isLocked = false
				} else {
					isIncorrect = true
				}
			}
		}
	}
	
	func delete() {
		guard !code.isEmpty else {
			return
		}
		code.removeLast()
		isIncorrect = false
	}
	
}

struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		LockView(isLocked: .constant(true))
	}
}
