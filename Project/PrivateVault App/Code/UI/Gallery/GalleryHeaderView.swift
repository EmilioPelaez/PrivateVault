//
//  GalleryHeaderView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 12/10/21.
//

import SwiftUI

struct GalleryHeaderView: View {
	enum ViewState {
		case navigation
		case search
		
		var other: ViewState {
			switch self {
			case .navigation: return .search
			case .search: return .navigation
			}
		}
	}
	
	@State var state: ViewState = .navigation
	@Binding var text: String
	var placeholder: String?
	
	var body: some View {
		HStack {
			ZStack {
				SearchBarView(text: $text, placeholder: placeholder)
					.opacity(0)
					.disabled(true)
				switch state {
				case .navigation:
					FolderNavigationView()
						.transition(.asymmetric(insertion: .move(edge: .leading),
																		removal: .move(edge: .trailing))
													.combined(with: .opacity)
													.animation(.linear))
				case .search:
					SearchBarView(text: $text, placeholder: placeholder)
						.transition(.asymmetric(insertion: .move(edge: .trailing),
																		removal: .move(edge: .leading))
													.combined(with: .opacity)
													.animation(.linear))
				}
			}
			Button(action: toggleState) {
				switch state {
				case .navigation:
					Image(systemName: "magnifyingglass")
						.transition(.scale)
				case .search:
					Image(systemName: "chevron.forward.square")
						.transition(.scale)
				}
			}
			.font(.title2)
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 8)
	}
	
	private func toggleState() {
		withAnimation {
			state = state.other
		}
	}
}

struct GalleryHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		GalleryHeaderView(state: .navigation, text: .constant("Hello"))
			.environmentObject(AppState())
			.previewLayout(.sizeThatFits)
		
		GalleryHeaderView(state: .search, text: .constant("Hello"))
			.environmentObject(AppState())
			.previewLayout(.sizeThatFits)
	}
}
