//
//  AttemptsRemaining.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import SwiftUI

struct AttemptsRemainingView: View {
	var attemptsRemaining: Int
	
	private var attemptsRemainingText: Text {
		switch attemptsRemaining {
		case 0: return Text("No Attempts Remaining")
		case 1: return Text("1 Attempt Remaining")
		case _: return Text("\(attemptsRemaining) Attempt Remaining")
		}
	}
	
	var body: some View {
		ZStack {
			attemptsRemainingText
			.bold()
			.padding(10)
			.background(Color.red.opacity(0.2))
			.clipShape(Capsule())
		}
	}
}

struct AttemptsRemainingView_Previews: PreviewProvider {
	static var previews: some View {
		AttemptsRemainingView(attemptsRemaining: 4)
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
