//
//  FileTypePickerView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct FileTypePickerView: View {
	
	enum FileType {
		case photo
		case document
		case audio
		
		var systemName: String {
			switch self {
			case .photo: return "camera"
			case .document: return "doc"
			case .audio: return "waveform"
			}
		}
		
		var name: String {
			switch self {
			case .photo: return "Photo"
			case .document: return "Document"
			case .audio: return "Audio"
			}
		}
	}
	
	@State var isExpanded: Bool = false
	var action: (FileType) -> Void
	
	var body: some View {
		HStack {
			Button {
				withAnimation {
					isExpanded.toggle()
				}
			} label: {
				Image(systemName: "plus")
					.font(.system(size: 30))
					.frame(width: 50, height: 50, alignment: .center)
					.foregroundColor(.white)
				.rotationEffect(.degrees(isExpanded ? 225 : 0))
			}
			if isExpanded {
				HStack(spacing: 10) {
					OptionIcon(fileType: .photo, action: buttonAction)
					OptionIcon(fileType: .document, action: buttonAction)
					OptionIcon(fileType: .audio, action: buttonAction)
				}
				.padding(.trailing, 10)
				.transition(.scale(scale: 0, anchor: .leading))
			}
		}
		.background(
			RoundedRectangle(cornerRadius: 25, style: .circular)
				.fill(Color.blue)
				.shadow(color: Color(white: 0, opacity: 0.2), radius: 4, x: 0, y: 2)
		)
	}
	
	func buttonAction(_ type: FileType) -> Void {
		withAnimation {
			isExpanded = false
		}
		action(type)
	}
}

extension FileTypePickerView {
	struct OptionIcon: View {
		var fileType: FileType
		var action: (FileType) -> Void
		var body: some View {
			Button(action: { action(fileType) } ) {
				VStack(spacing: 2) {
					Image(systemName: fileType.systemName)
						.font(.system(size: 20))
						.frame(width: 40, height: 40, alignment: .center)
						.background(Circle().fill(Color.white))
						.foregroundColor(.blue)
				}
			}
		}
	}
}

struct FileTypePickerView_Previews: PreviewProvider {
	static var previews: some View {
		FileTypePickerView(isExpanded:  true) { _ in }
			.padding()
			.previewLayout(.sizeThatFits)
		FileTypePickerView() { _ in }
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
