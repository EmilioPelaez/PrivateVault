//
//  LockView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct LockView: View {
	enum CodeState {
		case undefined
		case correct
		case incorrect
	}

	@EnvironmentObject private var settings: UserSettings
	@Binding var isLocked: Bool
	@State var code = ""
	@State var attempts = 0
	@State var codeState: CodeState = .undefined
	@State var incorrectAnimation = false
	@State var isLockedOut = false

	var maxDigits: Int { settings.passcode.count }
	var codeIsFullyEntered: Bool { code.count == maxDigits }
	var codeIsCorrect: Bool { code == settings.passcode }

	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()
			VStack(spacing: 25) {
				AttemptsRemainingView(attemptsRemaining: settings.maxAttempts - attempts)
					.opacity(attempts > 0 ? 1.0 : 0.0)
				InputDisplay(input: $code, codeLength: settings.codeLength, textColor: textColor, displayColor: displayColor)
					.shake(incorrectAnimation, distance: 10, count: 4)
				BlurringView(isBlurred: $isLockedOut ) {
					KeypadView(input: input, delete: delete) {
						BiometricAuthenticationButton {
							allowEntry()
						}
					}
				}
			}
			.frame(maxWidth: 280)
		}
	}

	var textColor: Color {
		switch codeState {
		case .correct: return .green
		case .incorrect: return .red
		case _: return .primary
		}
	}

	var displayColor: Color? {
		switch codeState {
		case .correct: return .green
		case .incorrect: return .red
		case _: return nil
		}
	}

	func input(_ string: String) {
		guard code.count < maxDigits else { return }
		code.append(string)

		if codeIsFullyEntered {
			withAnimation {
				if codeIsCorrect {
					allowEntry()
				} else {
					rejectEntry()
				}
			}
			return
		}

		codeState = .undefined
	}

	func delete() {
		guard !code.isEmpty else {
			return
		}
		code.removeLast()
		codeState = .undefined
	}

	func allowEntry() {
		codeState = .correct
		code = Array(repeating: "●", count: settings.codeLength).joined()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			withAnimation {
				isLocked = false
				codeState = .undefined
				attempts = 0
				code = ""
				if settings.sound { SoundEffect.success.play() }
			}
		}
	}

	func rejectEntry() {
		code = ""
		attempts += 1
		codeState = .incorrect
		incorrectAnimation.toggle()
		if settings.sound { SoundEffect.failure.play() }
		if attempts == settings.maxAttempts { isLockedOut = true }
	}
}

struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		LockView(isLocked: .constant(true))
			.environmentObject(UserSettings())
	}
}
