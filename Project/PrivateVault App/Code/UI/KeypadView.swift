//
//  LockView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI
import AudioToolbox

struct KeypadView: View {
	@Binding var code: String
	let maxDigits: Int
	let isIncorrect: Bool
	
	var columns: [GridItem] {
		[
			GridItem(.flexible(minimum: 100, maximum: 220)),
			GridItem(.flexible(minimum: 100, maximum: 220)),
			GridItem(.flexible(minimum: 100, maximum: 220))
		]
	}
	
	var body: some View {
		VStack(spacing: 20) {
			Spacer()
			Text(isIncorrect ? "Wrong password, try again.": "")
				.foregroundColor(.red)
			InputDisplay(codeCount: code.count, textColor: isIncorrect ? .red : .primary)
				.frame(maxWidth: .infinity)
			LazyVGrid(columns: columns, alignment: .center, content: {
				ForEach(1..<10){ index in
					KeyButton(title: Text("\(index)"), color: Color(.secondarySystemFill)) {
						generateFeedback(.rigid)
						guard code.count < maxDigits else { return }
						code.append("\(index)")
					}
				}
				Spacer()
				KeyButton(title: Text("0"), color: Color(.secondarySystemFill)) {
					generateFeedback(.rigid)
					guard code.count < maxDigits else { return }
					code.append("0")
				}
				.aspectRatio(1, contentMode: .fill)
				.clipShape(Circle())
				KeyButton(title: Image(systemName: "delete.left"), color: Color(#colorLiteral(red: 0.8059458137, green: 0.1390043199, blue: 0.1966293752, alpha: 1))){
					generateFeedback(.rigid)
					guard code.count > 0 else { return }
					code.removeLast()
				}
			})
			.frame(maxWidth: .infinity)
			Spacer()
		}
		.fixedSize(horizontal: true, vertical: false)
		.onChange(of: code) { _ in
			if isIncorrect {
				generateFeedback(.rigid)
			}
		}
	}
}

struct InputDisplay: View {
	let codeCount: Int
	let textColor: Color

	var body: some View {
		RoundedRectangle(cornerRadius: 10, style: .continuous)
			.foregroundColor(Color(.secondarySystemFill))
			.overlay(
				Text(String(repeating: "*", count: codeCount))
					.foregroundColor(textColor)
					.font(.custom("Keypad", fixedSize: 100))
					.bold()
					.padding(.top, 45)
			)
			.frame(height: 100)
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
					.foregroundColor(.white)
			}
		})
		.aspectRatio(1, contentMode: .fill)
		.clipShape(Circle())
	}
}


struct LockView_Previews: PreviewProvider {
	@State static var code = ""

	static var previews: some View {
		KeypadView(code: $code, maxDigits: 5, isIncorrect: false)
	}
}

extension UIDevice {
	static var isiPad: Bool { current.userInterfaceIdiom == .pad }
	static var supportsHapticFeedback: Bool { !isiPad }
}

private func generateFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
	if UIDevice.supportsHapticFeedback {
		UIImpactFeedbackGenerator(style: style).impactOccurred()
	} else {
		AudioServicesPlaySystemSound(SystemSoundID(UInt32(1104)))
	}
}
