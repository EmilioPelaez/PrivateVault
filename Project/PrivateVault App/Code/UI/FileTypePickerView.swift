//
//  FileTypePickerView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI


enum FileTypeIcon {
	case photo
	case document
	case audio
	
	var systemName: String {
		switch self {
			case .photo: return "camera.circle.fill"
			case .document: return "doc.circle.fill"
			case .audio: return "waveform.circle.fill"
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

struct FileTypePickerView: View {
	var action: (FileTypeIcon) -> Void
    var body: some View {
		VStack {
			HStack(spacing: 30) {
				FileOptionIcon(fileType: .photo, action: action)
				FileOptionIcon(fileType: .document, action: action)
				FileOptionIcon(fileType: .audio, action: action)
			}
		}
    }
}

struct FileOptionIcon: View {
	var fileType: FileTypeIcon
	var action: (FileTypeIcon) -> Void
	var body: some View {
		Button(action: {action(fileType)} ) {
			VStack(spacing: 2) {
				Circle()
					.strokeBorder(lineWidth: 2)
					.frame(width:45, height: 50, alignment: .center)
					.overlay(
						Image(systemName: fileType.systemName)
							.font(.largeTitle)
							.aspectRatio(contentMode: .fit)
					)
				Text("\(fileType.name)")
			}
		}
	}
}

struct FileTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
		FileTypePickerView(){ _ in}
    }
}
