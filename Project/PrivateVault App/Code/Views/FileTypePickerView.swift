//
//  FileTypePickerView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct FileTypePickerView: View {
	enum FileType: CaseIterable, Identifiable {
		case camera
		case album
		case document
		case scan

		var systemName: String {
			switch self {
			case .camera: return "camera"
			case .album: return "photo.on.rectangle"
			case .document: return "folder"
			case .scan: return "doc.text.viewfinder"
			}
		}

		var name: String {
			switch self {
			case .camera: return "Camera"
			case .album: return "Album"
			case .document: return "Document"
			case .scan: return "Document Scan"
			}
		}

		var id: Int { FileType.allCases.firstIndex(of: self) ?? 0 }
	}

	@State var isExpanded: Bool = false
	let height: CGFloat = 60
	let margin: CGFloat = 5
	var action: (FileType) -> Void

	var body: some View {
		HStack {
			Button {
				withAnimation {
					isExpanded.toggle()
				}
			} label: {
				Image(systemName: "plus")
					.font(.system(size: height / 2))
					.frame(width: height, height: height)
					.foregroundColor(.white)
				.rotationEffect(.degrees(isExpanded ? 225 : 0))
			}
			if isExpanded {
				HStack(spacing: margin) {
					ForEach(FileType.allCases) {
						OptionIcon(fileType: $0, height: height - margin * 2, action: buttonAction)
					}
				}
				.padding(.trailing, margin)
				.transition(.scale(scale: 0, anchor: .leading))
			}
		}
		.background(
			RoundedRectangle(cornerRadius: 30, style: .circular)
				.fill(Color.blue)
				.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
		)
	}

	func buttonAction(_ type: FileType) {
		withAnimation {
			isExpanded = false
		}
		action(type)
	}
}

extension FileTypePickerView {
	struct OptionIcon: View {
		let fileType: FileType
		let height: CGFloat
		let action: (FileType) -> Void

		var body: some View {
			Button {
				action(fileType)
			} label: {
				VStack(spacing: 2) {
					Image(systemName: fileType.systemName)
						.font(.system(size: height / 2))
						.frame(width: height, height: height)
						.background(Circle().fill(Color.white))
						.foregroundColor(.blue)
				}
			}
		}
	}
}

struct FileTypePickerView_Previews: PreviewProvider {
	static var previews: some View {
		FileTypePickerView(isExpanded: true) { _ in }
			.padding()
			.previewLayout(.sizeThatFits)
		FileTypePickerView { _ in }
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
