//
//  ItemFilter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import Foundation

class ItemFilter: ObservableObject {
	
	@Published var disabledTypes: Set<StoredItem.DataType> = []
	@Published var selectedTags: Set<Tag> = []
	@Published var searchText: String = ""
	
	static func preview(with preview: PreviewEnvironment = .init()) -> ItemFilter {
		let filter = ItemFilter()
		filter.selectedTags = Set(preview.tags.filter { _ in Bool.random() })
		return filter
	}
	
	func toggle(_ tag: Tag) {
		if selectedTags.contains(tag) {
			selectedTags.remove(tag)
		} else {
			selectedTags.insert(tag)
		}
	}
	
	func toggle(_ type: StoredItem.DataType) {
		if disabledTypes.contains(type) {
			disabledTypes.remove(type)
		} else {
			disabledTypes.insert(type)
		}
	}
	
	func clear() {
		disabledTypes = []
		selectedTags = []
		searchText = ""
	}
	
}
