//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct KeypadView: View {
	var columns: [GridItem] {
		[
			GridItem(.flexible()),
			GridItem(.flexible()),
			GridItem(.flexible())
		]
	}
	
	let input: (String) -> Void
	let delete: () -> Void
	
	var body: some View {
		LazyVGrid(columns: columns, alignment: .center) {
			ForEach(1..<10) { index in
				KeyButton(title: Text("\(index)"), color: Color(.tertiarySystemFill)) {
					FeedbackGenerator.impact(.rigid)
					input("\(index)")
				}
			}
			Spacer()
			KeyButton(title: Text("0"), color: Color(.tertiarySystemFill)) {
				FeedbackGenerator.impact(.rigid)
				input("0")
			}
			.aspectRatio(1, contentMode: .fill)
			.clipShape(Circle())
			KeyButton(title: Image(systemName: "delete.left"), color: .red) {
				FeedbackGenerator.impact(.rigid)
				delete()
			}
		}
	}
}



struct KeyButton<Body: View>: View {
	var title: Body
	var color: Color
	var action: () -> Void
	var body: some View {
		Button(action: action, label: {
			ZStack {
				color
				title
					.font(.largeTitle)
					.foregroundColor(.primary)
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

