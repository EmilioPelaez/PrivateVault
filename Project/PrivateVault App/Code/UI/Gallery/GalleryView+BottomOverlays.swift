//
//  GalleryView+BottomOverlays.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import SwiftUI

extension GalleryView {
	
	var actionButtons: some View {
		ZStack(alignment: .bottomLeading) {
			Color.clear
			if showTags {
				tagCloseView
			}
			HStack(alignment: .bottom) {
				FileTypePickerView(action: selectType)
					.sheet(item: $currentSheet, content: sheetFor)
				tagOverlay
			}
			.padding(.horizontal)
			.padding(.bottom, 10)
		}
	}
	
	var tagCloseView: some View {
		Color(white: 0, opacity: 0.001)
			.onTapGesture {
				withAnimation {
					showTags = false
				}
			}
	}
	
	var tagOverlay: some View {
		VStack(alignment: .leading) {
			if showTags {
				FiltersView(filter: filter) {
					withAnimation {
						showTags = false
						currentSheet = .tags
					}
				}
				.transition(.scale(scale: 0, anchor: .bottomLeading))
			}
			Button {
				withAnimation { showTags.toggle() }
			}
			label: {
				ZStack {
					Circle()
						.fill(Color.green)
						.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
					Group {
						if showTags {
							Image(systemName: "tag.fill")
						} else {
							Image(systemName: "tag")
						}
					}
					.font(.system(size: 30))
					.foregroundColor(.white)
					.transition(.opacity)
				}
				.frame(width: 60, height: 60)
			}
		}
	}
	
	var processingView: some View {
		ZStack(alignment: .bottomTrailing) {
			Color.clear
			if showProcessing {
				ImportProcessView()
					.transition(.opacity.combined(with: .move(edge: .bottom)))
			}
		}
		.padding()
		.onChange(of: persistenceController.creatingFiles) { creating in
			withAnimation { showProcessing = creating }
		}
	}
	
}
