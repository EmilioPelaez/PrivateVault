//
//  FileTypePickerView.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI


enum FileTypeIcon {
	case photo
	case file
	case audio
	
	var systemName: String {
		switch self {
			case .photo: return "camera.circle.fill"
			case .file: return "doc.circle.fill"
			case .audio: return "waveform.circle.fill"
		}
	}
	
	var name: String {
		switch self {
			case .photo: return "Photo"
			case .file: return "Document"
			case .audio: return "Audio"
		}
	}
	
}

struct FileTypePickerView: View {
    var body: some View {
		VStack {
			HStack(spacing: 30) {
				FileOptionIcon(fileType: .photo)
				FileOptionIcon(fileType: .file)
				FileOptionIcon(fileType: .audio)
			}
		}
    }
}

struct FileOptionIcon: View {
	var fileType: FileTypeIcon
	var body: some View {
		Button(action: {} ) {
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
        FileTypePickerView()
    }
}
