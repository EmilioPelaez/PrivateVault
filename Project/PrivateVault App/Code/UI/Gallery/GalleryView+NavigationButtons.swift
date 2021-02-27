//
//  GalleryView+NavigationButtons.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import SwiftUI

extension GalleryView {
	var leadingButtons: some ToolbarContent {
		ToolbarItemGroup(placement: .navigationBarLeading) {
			Button {
				currentSheet = .settings
			} label: {
				Image(systemName: "gearshape")
			}
			Button {
				withAnimation { isLocked = true }
			} label: {
				Image(systemName: "lock.circle")
			}
		}
	}
	
	var trailingButton: some ToolbarContent {
		ToolbarItemGroup(placement: .navigationBarTrailing) {
			Menu {
				Button {
					withAnimation { settings.showDetails.toggle() }
				}
				label: {
					if settings.showDetails {
						Text("Hide File Details")
					} else {
						Text("Show File Details")
					}
					Image(systemName: "info.circle")
				}
				Menu {
					ForEach(1..<6) { columns in
						Button {
							withAnimation { settings.columns = columns }
						}
						label: {
							if columns == 1 {
								Text("\(columns) Column")
							} else {
								Text("\(columns) Columns")
							}
							Image(systemName: "\(columns).circle")
						}
					}
				} label: {
					Text("Columns")
					Image(systemName: "rectangle.split.3x1")
				}
			} label: {
				Image(systemName: "ellipsis.circle")
					.font(.system(size: 22))
			}
		}
	}
}
