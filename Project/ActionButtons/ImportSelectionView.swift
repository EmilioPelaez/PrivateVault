//
//  ImportSelectionView.swift
//  ActionButtons
//
//  Created by Emilio Peláez on 26/04/22.
//

import SharedUI
import SwiftUI

public struct ImportSelectionView: View {
	@State var isExpanded = false
	let height: CGFloat = 60
	let margin: CGFloat = 5
	
	public init(isExpanded: Bool = false) {
		_isExpanded = .init(initialValue: isExpanded)
	}
	
	public var body: some View {
		VStack {
			if isExpanded {
				VStack(spacing: margin) {
					ForEach(ImportType.allCases) {
						ImportButton(type: $0, height: height - margin * 2)
							.receiveEvent(ImportEvent.self) {
								addButtonAction()
								return .notHandled
							}
					}
				}
				.padding(.top, margin)
				.transition(.scale(scale: .ulpOfOne, anchor: .bottom))
			}
			Button(action: addButtonAction) {
				Image(systemName: "plus")
					.font(.system(size: height / 2))
					.frame(width: height, height: height)
					.foregroundColor(.white)
					.rotationEffect(.degrees(isExpanded ? 225 : 0))
			}
			
		}
		.background {
			Capsule()
				.fill(Color.blue)
				.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
		}
	}
	
	func addButtonAction() {
		withAnimation {
			isExpanded.toggle()
		}
	}
}

struct ImportSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ImportSelectionView(isExpanded: false)
				.preparePreview()
			ImportSelectionView(isExpanded: true)
				.preparePreview()
		}
		.previewColorSchemes()
	}
}
