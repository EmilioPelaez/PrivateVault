//
//  GalleryGrid.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import CGMath
import SharedUI
import SwiftUI
import HierarchyResponder

public struct GalleryGrid: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	let items: [GalleryItem]
	
	var columns: [GridItem] {
		[.init(.adaptive(minimum: 150, maximum: 250),
					 spacing: .paddingMedium,
					 alignment: .center)]
	}
	
	public init(items: [GalleryItem]) {
		self.items = items
	}
	
	public var body: some View {
		LazyVGrid(columns: columns, alignment: .center, spacing: .paddingMedium) {
			ForEach(items) { item in
				GalleryItemCell(item: item)
					.onTapGesture { triggerEvent(ItemSelectedEvent(item: item)) }
					.contextMenu { contextMenu(for: item) }
			}
		}
	}
	
	func contextMenu(for item: GalleryItem) -> some View {
		ForEach(ItemContextEvent.Action.allCases) { action in
			Button(role: action.role) {
				let event = ItemContextEvent(item: item, action: action)
				triggerEvent(event)
			} label: {
				Label(action.title, systemImage: action.systemImage)
			}
		}
	}
	
}

struct Gallery_Previews: PreviewProvider {
	static var previews: some View {
		GalleryGrid(items:
									(0..<10)
			.map { "\($0)" }
			.map { GalleryItem(id: $0, title: "Hello", subtitle: "World", kind: .folder) }
		)
			.frame(maxWidth: 500)
			.preparePreview()
	}
}
