//
//  PreviewSelection.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 12/3/21.
//

import Foundation
import Persistence

public enum PreviewSelection: Identifiable {
	public var id: UUID { UUID() }
	
	case url(URL)
	case quickLook(QuickLookView.Selection)
	
	public init?(item: StoredItem, list: [StoredItem]) {
		if item.dataType == .url, let url = item.remoteUrl {
			self = .url(url)
		} else if item.dataType != .url {
			var itemIndex = list.firstIndex(of: item) ?? 0
			var newList: [StoredItem] = []
			list.enumerated().forEach { index, element in
				if element.dataType == .url {
					if itemIndex >= index {
						itemIndex -= 1
					}
				} else {
					newList.append(element)
				}
			}
			self = .quickLook(.init(items: newList, selectedIndex: itemIndex))
		} else {
			return nil
		}
	}
}
