//
//  ItemFilter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import Foundation

class ItemFilter: ObservableObject {
	
	@Published var selectedTypes: Set<StoredItem.DataType> = []
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
		if selectedTypes.contains(type) {
			selectedTypes.remove(type)
		} else {
			selectedTypes.insert(type)
		}
	}
	
	func deleted(_ tags: [Tag]) {
		tags.forEach { selectedTags.remove($0) }
	}
	
	func clear() {
		selectedTypes = []
		selectedTags = []
		searchText = ""
	}
	
	func apply(_ item: StoredItem) -> Bool {
		if !selectedTypes.isEmpty, !selectedTypes.contains(item.dataType) {
				return false
		}
		if !selectedTags.isEmpty, !selectedTags.allSatisfy({ item.tags?.contains($0) ?? false }) {
			return false
		}
		if !searchText.isEmpty, !(item.name?.localizedCaseInsensitiveContains(searchText) ?? false) {
			return false
		}
		return true
	}
	
}
