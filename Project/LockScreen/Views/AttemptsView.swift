//
//  AttemptsView.swift
//  LockScreen
//
//  Created by Emilio Peláez on 03/04/22.
//

import SwiftUI

struct AttemptsView: View {
	@Environment(\.passcodeMaxAttempts) var passcodeMaxAttempts
	@Environment(\.passcodeAttemptsRemaining) var passcodeAttemptsRemaining
	@Environment(\.passcodeLockedOutDate) var passcodeLockedOutDate
	@Environment(\.passcodeLockedOut) var passcodeLockedOut
	
	var attemptsRemainString: String {
		"\(passcodeAttemptsRemaining) Attempt\(passcodeAttemptsRemaining != 1 ? "s" : "") Remaining"
	}
	
	var body: some View {
		if let date = passcodeLockedOutDate, passcodeLockedOut {
			Text("Try again in ") +
			Text(date, style: .timer)
		} else if passcodeAttemptsRemaining < passcodeMaxAttempts {
			Text(attemptsRemainString)
		}
	}
}

struct AttemptsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AttemptsView()
				.environment(\.passcodeAttemptsRemaining, 4)
			AttemptsView()
				.environment(\.passcodeLockedOut, true)
				.environment(\.passcodeLockedOutDate, Date().addingTimeInterval(100))
		}
		.preparePreview()
	}
}
