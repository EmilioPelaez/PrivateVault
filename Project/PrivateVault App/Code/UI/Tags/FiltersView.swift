//
//  FiltersView.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import SwiftUI

struct FiltersView: View {
	@ObservedObject var filter: ItemFilter
	
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)], animation: .default)
	var tags: FetchedResults<Tag>
	
	let manageTagsAction: () -> Void
	
	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			LazyVStack(spacing: 0) {
				ForEach(StoredItem.DataType.allCases) { type in
					Row(imageName: type.systemImageName, title: type.name, selected: filter.selectedTypes.contains(type)) {
						filter.toggle(type)
					}
					if type != StoredItem.DataType.allCases.last {
						Divider()
					}
				}
			}
			Color(.separator)
				.opacity(0.5)
				.frame(height: 6)
				.padding(.top, 4)
			if tags.isEmpty {
				Text("No Tags")
					.font(.callout)
					.padding(.horizontal)
					.padding(.vertical, 4)
			} else {
				ScrollView {
					LazyVStack(spacing: 0) {
						ForEach(tags) { tag in
							Row(imageName: "tag", title: tag.name ?? "Unnamed Tag", selected: filter.selectedTags.contains(tag)) {
								filter.toggle(tag)
							}
							if tag != tags.last {
								Divider()
							}
						}
					}
					.padding(.vertical, 4)
				}
				.frame(maxHeight: 200)
			}
			Color(.separator)
				.opacity(0.5)
				.frame(height: 6)
				.padding(.bottom, 4)
			Button {
				manageTagsAction()
			}
			label: {
				HStack {
					Image(systemName: "square.and.pencil")
						.frame(width: 25)
					Text("Edit Tags")
						.font(.callout)
					Spacer()
				}
				.foregroundColor(.primary)
				.padding(.horizontal)
				.padding(.vertical, 4)
			}
		}
		.padding(.vertical, 6)
		.background(VisualEffectView(style: .systemThickMaterial))
		.cornerRadius(10)
		.frame(maxWidth: 220)
		.shadow(color: Color(white: 0, opacity: 0.2), radius: 50, x: 0, y: 0)
	}
	
	struct Row: View {
		let imageName: String
		let title: String
		let selected: Bool
		let action: () -> Void
		var body: some View {
			Button {
				withAnimation { action() }
			}
			label: {
				HStack {
					Image(systemName: imageName)
						.frame(width: 25)
					Text(title)
						.font(.callout)
					Spacer()
					RadioButton(selected: selected, size: 20, color: .primary)
				}
				.foregroundColor(.primary)
				.padding(.horizontal)
				.padding(.vertical, 4)
			}
		}
	}
}

struct FiltersView_Previews: PreviewProvider {
	static let preview = PreviewEnvironment()
	
	static var previews: some View {
		FiltersView(filter: .preview(with: preview)) {}
			.environment(\.managedObjectContext, preview.context)
			.previewLayout(.sizeThatFits)
	}
}
