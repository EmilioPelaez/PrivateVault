//
//  ItemFilter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import Foundation
import Persistence

public class ItemFilter: ObservableObject {
	
	@Published public var selectedTypes: Set<StoredItem.DataType> = []
	@Published public var selectedTags: Set<Tag> = []
	@Published public var searchText: String = ""
	
	public init() {}
	
	public static func preview(with preview: PreviewEnvironment = .init()) -> ItemFilter {
		let filter = ItemFilter()
		filter.selectedTags = Set(preview.tags.filter { _ in Bool.random() })
		return filter
	}
	
	public func toggle(_ tag: Tag) {
		if selectedTags.contains(tag) {
			selectedTags.remove(tag)
		} else {
			selectedTags.insert(tag)
		}
	}
	
	public func toggle(_ type: StoredItem.DataType) {
		if selectedTypes.contains(type) {
			selectedTypes.remove(type)
		} else {
			selectedTypes.insert(type)
		}
	}
	
	public func deleted(_ tags: [Tag]) {
		tags.forEach { selectedTags.remove($0) }
	}
	
	public func clear() {
		selectedTypes = []
		selectedTags = []
		searchText = ""
	}
	
	public func apply(_ item: StoredItem) -> Bool {
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
