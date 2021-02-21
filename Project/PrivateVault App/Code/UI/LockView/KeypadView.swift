//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct KeypadView: View {
	let input: (String) -> Void
	let delete: () -> Void
	
	var body: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center) {
			ForEach(1..<10) { index in
				KeyButton(title: Text("\(index)"), color: Color(.tertiarySystemFill), textColor: .primary) {
					FeedbackGenerator.impact(.rigid)
					input("\(index)")
				}
			}
			Spacer()
			KeyButton(title: Text("0"), color: Color(.tertiarySystemFill), textColor: .primary) {
				FeedbackGenerator.impact(.rigid)
				input("0")
			}
			.aspectRatio(1, contentMode: .fill)
			.clipShape(Circle())
			KeyButton(title: Image(systemName: "delete.left"), color: .red, textColor: .white) {
				FeedbackGenerator.impact(.rigid)
				delete()
			}
		}
	}
}



struct KeyButton<Body: View>: View {
	let title: Body
	let color: Color
	let textColor: Color
	let action: () -> Void
	var body: some View {
		Button(action: action, label: {
			ZStack {
				color
				title
					.font(.largeTitle)
					.foregroundColor(textColor)
			}
		})
		.aspectRatio(1, contentMode: .fill)
		.clipShape(Circle())
	}
}


struct KeypadView_Previews: PreviewProvider {
	@State static var code = ""
	
	static var previews: some View {
		KeypadView(input: { _ in }, delete: { })
	}
}
