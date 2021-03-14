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
	@EnvironmentObject private var passcodeManager: PasscodeManager
	@Binding var isLocked: Bool
	@State var code = ""
	@State var attempts = 0
	@State var codeState: CodeState = .undefined
	@State var incorrectAnimation = false
	@State var lockedOutDate: Date?
	var isLockedOut: Bool {
		lockedOutDate != nil
	}

	var maxDigits: Int { passcodeManager.passcode.count }
	var codeIsFullyEntered: Bool { code.count == maxDigits }
	var codeIsCorrect: Bool { code == passcodeManager.passcode }

	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State var update = true
	
	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()
			VStack(spacing: 25) {
				AttemptsRemainingView(attemptsRemaining: settings.maxAttempts - attempts, unlockDate: lockedOutDate)
					.opacity(attempts > 0 ? 1.0 : 0.0)
				InputDisplay(input: $code, codeLength: passcodeManager.passcodeLength, textColor: textColor, displayColor: displayColor)
					.shake(incorrectAnimation, distance: 10, count: 4)
				KeypadView(input: input, delete: delete) {
					BiometricAuthenticationButton {
						allowEntry()
					}
				}
				.lockedOut(isLockedOut)
			}
			.frame(maxWidth: 280)
			.scaledForSmallScreen(cutoff: 640, scale: 0.9)
			.onReceive(timer) { _ in
				guard let lockedOutDate = lockedOutDate else {
					return
				}
				if lockedOutDate < Date() {
					withAnimation {
						self.lockedOutDate = nil
						attempts = 0
						codeState = .undefined
					}
				} else {
					update.toggle()
				}
			}
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
		code = Array(repeating: "●", count: passcodeManager.passcodeLength).joined()
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
		if attempts == settings.maxAttempts {
			lockedOutDate = Date().addingTimeInterval(10)
		}
	}
}

struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		LockView(isLocked: .constant(true))
			.environmentObject(UserSettings())
			.environmentObject(PasscodeManager())
	}
}
