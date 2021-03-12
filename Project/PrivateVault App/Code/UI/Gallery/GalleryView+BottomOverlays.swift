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
				tagOverlay
			}
			.padding(.horizontal)
			.padding(.bottom, 10)
		}
	}
	
	var selectionButtons: some View {
		ZStack(alignment: .bottomLeading) {
			Color.clear
			HStack {
				ColorButton(color: .red, imageName: "trash") {
					switch selectedItems.count {
					case 1:
						currentAlert = .deleteItemConfirmation(selectedItems.map { $0 }[0])
					case 2...:
						currentAlert = .deleteItemsConfirmation(selectedItems)
					case _:
						withAnimation {
							multipleSelection = false
							selectedItems = []
						}
					}
					guard settings.sound else { return }
					SoundEffect.close.play()
				}
				ColorButton(color: .orange, imageName: "square.and.arrow.up") {
					guard !selectedItems.isEmpty else {
						guard settings.sound else { return }
						SoundEffect.failure.play()
						return
					}
					let items = selectedItems.filter { $0.dataType != .url }
					let urls = selectedItems.filter { $0.dataType == .url }.compactMap { $0.remoteUrl }
					if items.isEmpty, !urls.isEmpty {
						self.currentSheet = .share(urls)
					} else {
						diskStore.add(items.map { $0 }) { result in
							let localUrls = result.compactMap { try? $0.get().url }
							self.currentSheet = .share(localUrls + urls)
						}
					}
					
					guard settings.sound else { return }
					SoundEffect.open.play()
				}
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
				.transition(.scale(scale: .ulpOfOne, anchor: .bottomLeading))
			}
			ColorButton(color: .green, imageName: showTags ? "tag.fill" : "tag", action: tagButtonAction)
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
	
	func tagButtonAction() {
		withAnimation { showTags.toggle() }
		guard settings.sound else { return }
		if showTags {
			SoundEffect.open.play()
		} else {
			SoundEffect.close.play()
		}
	}
	
}
