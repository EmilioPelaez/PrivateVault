//
//  LockView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

enum EntryStatus {
	case accepted
	case rejected
	case undetermined
}

struct LockView: View {
	let password = "1234"
	let maxAttempts = 5
	@Binding var isLocked: Bool
	@State var code: String = ""
	@State var attempts: Int = 0
	@State var isLockedOut: Bool = false
	@State var entryStatus: EntryStatus = .undetermined
	let maxDigits: Int = 4
	
	var codeIsFullyEntered: Bool {
		code.count == maxDigits
	}
	
	var codeIsCorrect: Bool {
		code == password
	}
	
	var body: some View {
		ZStack {
			Color(.systemBackground).ignoresSafeArea()
			VStack(spacing: 25) {
				AttemptsRemainingView(attemptsRemaining: maxAttempts - attempts)
					.opacity(attempts > 0 ? 1.0 : 0.0)
				InputDisplay(codeLength: maxDigits, input: $code, textColor: textColor)
					.shake(entryStatus, distance: 10, count: 4)
					.soundEffect(soundEffect: entryStatus == .rejected ? .failure : .none )
					.soundEffect(soundEffect: !isLocked ? .success : .none)
				BlurringView(isBlurred: $isLockedOut ) {
					KeypadView(input: input, delete: delete)
				}
			}
			.frame(maxWidth: 280)
		}
	}
	
	var textColor: Color {
		switch entryStatus {
		case .accepted:
			return .green
		case .rejected:
			return .red
		case .undetermined:
			return .primary
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
		
		entryStatus = .undetermined
	}
	
	func delete() {
		guard !code.isEmpty else {
			return
		}
		code.removeLast()
		entryStatus = .undetermined
	}
	
	func allowEntry() -> Void {
		attempts = 0
		isLocked = false
		code = ""
		entryStatus = .accepted
	}
	
	func rejectEntry() -> Void {
		code = ""
		attempts += 1
		entryStatus = .rejected
		if attempts == maxAttempts { isLockedOut = true }
	}
}

struct LockView_Previews: PreviewProvider {
	static var previews: some View {
		LockView(isLocked: .constant(true))
	}
}
