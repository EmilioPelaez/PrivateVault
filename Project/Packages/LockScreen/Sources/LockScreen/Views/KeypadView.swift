//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import Middleware
import SharedUI
import SwiftUI

public struct KeypadView<Button: View>: View {
	@EnvironmentObject private var settings: UserSettings
	let input: (String) -> Void
	let delete: () -> Void
	let bottomLeftInput: () -> (Button)
	
	public init(
		input: @escaping (String) -> Void,
		delete: @escaping () -> Void,
		bottomLeftInput: @escaping () -> (Button)
	) {
		self.input = input
		self.delete = delete
		self.bottomLeftInput = bottomLeftInput
	}
	
	public var body: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center) {
			ForEach(1 ..< 10) { index in
				KeyButton(title: Text("\(index)"), color: Color(.tertiarySystemFill), textColor: .primary) {
					feedback()
					input("\(index)")
				}
			}
			bottomLeftInput()
			KeyButton(title: Text("0"), color: Color(.tertiarySystemFill), textColor: .primary) {
				feedback()
				input("0")
			}
			.aspectRatio(1, contentMode: .fill)
			.clipShape(Circle())
			KeyButton(title: Image(systemName: "delete.left"), color: .red, textColor: .white) {
				feedback()
				delete()
			}
		}
	}
	
	func feedback() {
		if settings.hapticFeedback { FeedbackGenerator.impact(.medium) }
		if settings.sound { SoundEffect.tap.play() }
	}
}

public struct KeyButton<Body: View>: View {
	let title: Body
	let color: Color
	let textColor: Color
	let action: () -> Void
	
	public init(title: Body, color: Color, textColor: Color, action: @escaping () -> Void) {
		self.title = title
		self.color = color
		self.textColor = textColor
		self.action = action
	}
	
	public var body: some View {
		Button(action: action) {
			title
				.font(.largeTitle)
				.foregroundColor(textColor)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.tintedGlass(color)
				.contentShape(Circle())
		}
		.aspectRatio(1, contentMode: .fill)
	}
}

struct KeypadView_Previews: PreviewProvider {
	@State static var code = ""

	static var previews: some View {
		KeypadView(input: { _ in }, delete: {}, bottomLeftInput: {
			Spacer()
		})
			.environmentObject(UserSettings())
	}
}
