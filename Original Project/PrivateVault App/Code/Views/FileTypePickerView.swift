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
		case clipboard

		var systemName: String {
			switch self {
			case .camera: return "camera"
			case .album: return "photo.on.rectangle"
			case .document: return "folder"
			case .scan: return "doc.text.viewfinder"
			case .clipboard: return "doc.on.clipboard"
			}
		}

		var name: String {
			switch self {
			case .camera: return "Camera"
			case .album: return "Album"
			case .document: return "Document"
			case .scan: return "Document Scan"
			case .clipboard: return "Clipboard"
			}
		}

		var id: Int { FileType.allCases.firstIndex(of: self) ?? 0 }
	}
	
	@EnvironmentObject var settings: UserSettings
	@State var isExpanded: Bool = demoImport
	let height: CGFloat = 60
	let margin: CGFloat = 5
	var action: (FileType) -> Void

	var body: some View {
		VStack {
			if isExpanded {
				VStack(spacing: margin) {
					ForEach(FileType.allCases) {
						OptionIcon(fileType: $0, height: height - margin * 2, action: pickerButtonAction)
					}
				}
				.padding(.top, margin)
				.transition(.scale(scale: .ulpOfOne, anchor: .bottom))
			}
			Button(action: addButtonAction) {
				Image(systemName: "plus")
					.font(.system(size: height / 2))
					.frame(width: height, height: height)
					.foregroundColor(.white)
					.rotationEffect(.degrees(isExpanded ? 225 : 0))
			}
			
		}
		.background(
			RoundedRectangle(cornerRadius: 30, style: .circular)
				.fill(Color.blue)
				.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
		)
	}
	
	func addButtonAction() {
		withAnimation {
			isExpanded.toggle()
		}
		guard settings.sound else { return }
		if isExpanded {
			SoundEffect.openLong.play()
		} else {
			SoundEffect.closeLong.play()
		}
	}
	
	func pickerButtonAction(_ type: FileType) {
		withAnimation {
			isExpanded = false
		}
		action(type)
		guard settings.sound else { return }
		SoundEffect.open.play()
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
			.environmentObject(UserSettings())
		FileTypePickerView { _ in }
			.padding()
			.previewLayout(.sizeThatFits)
			.environmentObject(UserSettings())
	}
}
