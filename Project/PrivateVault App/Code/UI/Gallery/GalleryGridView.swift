//
//  GalleryGridView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import SwiftUI

struct GalleryGridView<E>: View where E: View {
	private func columns(spacing: CGFloat) -> [GridItem] {
		[
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing),
			GridItem(.flexible(), spacing: spacing)
		]
	}
	
	@Binding var data: [Item]
	@Binding var contentMode: ContentMode
	@Binding var showDetails: Bool
	let emptyView: () -> E
	let selection: (Item) -> Void

	init(
		data: Binding<[Item]>,
		contentMode: Binding<ContentMode>,
		showDetails: Binding<Bool>,
		emptyView: @autoclosure @escaping () -> E,
		selection: @escaping (Item) -> Void
	) {
		self._data = data
		self._contentMode = contentMode
		self._showDetails = showDetails
		self.emptyView = emptyView
		self.selection = selection
	}
	
	var body: some View {
		if data.isEmpty {
			VStack {
				Spacer()
				HStack {
					Spacer()
					emptyView()
					Spacer()
				}
				Spacer()
			}
		} else {
			ScrollView {
				LazyVGrid(columns: columns(spacing: 4), spacing: 4) {
					ForEach(data) { item in
						GalleryGridCell(item: item, contentMode: $contentMode, showDetails: $showDetails)
							.onTapGesture { selection(item) }
					}
				}
				.padding(4)
				.padding(.bottom, 55)
			}
		}
	}
}

struct GalleryGridView_Previews: PreviewProvider {
	static let data: [Item] = .examples
	static var previews: some View {
		GalleryGridView(data: .constant(data), contentMode: .constant(.fill), showDetails: .constant(true), emptyView: EmptyView()) { _ in }
		
		GalleryGridView(data: .constant(data), contentMode: .constant(.fill), showDetails: .constant(false), emptyView: EmptyView()) { _ in }
	}
}
