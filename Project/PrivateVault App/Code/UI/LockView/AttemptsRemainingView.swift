//
//  AttemptsRemaining.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import SwiftUI



struct AttemptsRemainingView: View {
	var attemptsRemaining: Int
	
	private var attemptsRemainingText:  String  {
		if attemptsRemaining > 1 {
			return "Attempts Remaining"
		} else {
			return "Attempt Remaining"
		}
	}
	var body: some View {
		ZStack {
			Text(
				attemptsRemaining > 0
					? "\(attemptsRemaining) \(attemptsRemainingText) "
					: "No Attempts Remaining"
			)
				.bold()
				.padding(10)
				.background(
					RoundedRectangle(cornerRadius: 25.0)
						.fill(Color.red)
						.opacity(0.3)
						.shadow(radius: 10 )
				)
		}
	}
}

struct AttemptsRemainingView_Previews: PreviewProvider {
	static var previews: some View {
		AttemptsRemainingView(attemptsRemaining: 4)
	}
}
