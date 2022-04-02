//
//  KeyButton.swift
//  LockScreen
//
//  Created by Emilio Peláez on 30/03/22.
//

import HierarchyResponder
import SwiftUI

struct KeyButton<Label: View>: View {
	let event: Event
	let opacity: Double
	let label: () -> Label
	
	init(event: Event, opacity: Double, label: @escaping () -> Label) {
		self.event = event
		self.opacity = opacity
		self.label = label
	}
	
	var body: some View {
		EventButton(event) {
			ZStack {
				Rectangle()
					.opacity(opacity)
				label()
			}
		}
		.foregroundStyle(.tint)
		.aspectRatio(1, contentMode: .fill)
		.clipShape(Circle())
	}
}

struct DummyEvent: Event {}
struct KeyButton_Previews: PreviewProvider {
	static var previews: some View {
		KeyButton(event: DummyEvent(), opacity: 0.25) {
			Text("5")
		}
	}
}
