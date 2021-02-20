//
//  BlurringView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import SwiftUI

struct BlurringView<Content>: View where Content: View {
	@Binding var isBlurred: Bool
	var backgroundContent: () -> Content
	
	private var blurRadius: CGFloat { isBlurred ? 8 : 0 }
	private var opacity: Double { isBlurred ? 1 : 0 }
	
	var body: some View {
		ZStack(alignment: .center) {
			backgroundContent()
				.blur(radius: blurRadius, opaque: false)
			
			if isBlurred {
				Color.white.opacity(0.001)
					.contentShape(Rectangle())
				Image(systemName: "lock")
					.font(.largeTitle)
					.foregroundColor(Color.black)
					.padding()
					.background(
						Circle().opacity(0.2)
							.foregroundColor(.green)
					)
			}
		}
    }
}

struct BlurringView_Previews: PreviewProvider {
    static var previews: some View {
		BlurringView(isBlurred: .constant(true)) {
			Text("Hello World")
		}
    }
}
