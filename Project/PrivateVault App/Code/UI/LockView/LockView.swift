//
//  LockView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct LockView: View {
	@EnvironmentObject private var settings: UserSettings
	@Binding var isLocked: Bool
	@State var code = ""
	@State var attempts = 0
	@State var isIncorrect = false
	@State var incorrectAnimation = false
	@State var isLockedOut = false
	
	var maxDigits: Int { settings.password.count }
	var codeIsFullyEntered: Bool { code.count == maxDigits }
	var codeIsCorrect: Bool { code == settings.password }
	
	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()
			VStack(spacing: 25) {
				AttemptsRemainingView(attemptsRemaining: settings.maxAttempts - attempts)
					.opacity(attempts > 0 ? 1.0 : 0.0)
				InputDisplay(input: $code, codeLength: settings.codeLength, textColor: textColor)
					.shake(incorrectAnimation, distance: 10, count: 4)
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
		switch (isIncorrect, isLocked) {
		case (_, false): return .green
		case (true, _): return .red
		case _: return .primary
		}
	}
	
	func input(_ string: String) {
		guard code.count < maxDigits else { return }
		code.append(string)
		
		if codeIsFullyEntered && codeIsCorrect {
			withAnimation {
				allowEntry()
			}
			return
		}
		
		if codeIsFullyEntered && !codeIsCorrect {
			withAnimation {
				rejectEntry()
			}
			return
		}
		
		isIncorrect = false
	}
	
	func delete() {
		guard !code.isEmpty else {
			return
		}
		code.removeLast()
		isIncorrect = false
	}
	
	func allowEntry() -> Void {
		attempts = 0
		isLocked = false
		code = ""
	}
	
	func rejectEntry() -> Void {
		code = ""
		attempts += 1
		isIncorrect = true
		incorrectAnimation.toggle()
		if attempts == settings.maxAttempts { isLockedOut = true }
	}
}

struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		LockView(isLocked: .constant(true))
			.environmentObject(UserSettings())
	}
}
