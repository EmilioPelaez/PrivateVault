//
//  LockView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct LockView: View {
	let password = "1234"
	let maxAttempts = 5
	@Binding var isLocked: Bool
	@State var code: String = ""
	@State var isIncorrect: Bool = false
	@State var attempts: Int = 0
	@State var isLockedOut: Bool = false
	let maxDigits: Int = 4
	
	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()
			VStack(spacing: 25) {
				AttemptsRemainingView(attemptsRemaining: maxAttempts - attempts)
					.opacity(attempts > 0 ? 1.0 : 0.0)
				InputDisplay(codeLength: maxDigits, input: $code, textColor: textColor)
					.shake(isIncorrect, distance: 10, count: 4)
					.soundEffect(soundEffect: isIncorrect ? .failure : .none )
					.soundEffect(soundEffect: !isLocked ? .success : .none)
				BlurringView(isBlurred: $isLockedOut ) {
					KeypadView(input: input, delete: delete)
				}
			}
			.frame(maxWidth: 280)
		}
	}

	var textColor: Color {
		guard code.count == maxDigits else { return .primary }

		return isIncorrect ? .red : .green
	}
	
	func input(_ string: String) {
		if (code.count ==  maxDigits) {
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
					attempts += 1
					print(attempts)
					isIncorrect = true
					if(attempts == maxAttempts) {isLockedOut = true}
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
