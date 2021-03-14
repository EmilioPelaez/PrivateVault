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
			if multipleSelection {
				Button {
					withAnimation {
						selectedItems = []
						multipleSelection = false
					}
				}
				label: {
					Text("Done")
				}
			}
			Menu {
				if !multipleSelection {
					Button {
						withAnimation {
							selectedItems = []
							multipleSelection = true
						}
					}
					label: {
						Text("Select")
						Image(systemName: "checkmark.circle")
					}
					Divider()
				}
				Button {
					withAnimation { settings.showDetails.toggle() }
				}
				label: {
					if settings.showDetails {
						Text("Hide Details")
					} else {
						Text("Show Details")
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
					Image(systemName: "chevron.right")
				}
				Menu {
					ForEach(SortMethod.allCases) { method in
						Button {
							withAnimation { settings.sort = method }
						}
						label: {
							Text(method.description)
							Image(systemName: method.systemImageName)
						}
					}
				} label: {
					Text("Sort By")
					Image(systemName: "chevron.right")
				}
			} label: {
				Image(systemName: "ellipsis.circle")
					.font(.title2)
			}
		}
	}
}
