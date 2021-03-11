//
//  StoredItem+DataType.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

extension StoredItem {
	enum DataType: Int16, Identifiable {
		case file
		case image
		case video
		case url
		
		var id: Int16 { rawValue }
	}

	var dataType: DataType {
		get { DataType(rawValue: dataTypeValue) ?? .file }
		set { dataTypeValue = newValue.rawValue }
	}
}

extension StoredItem.DataType {
	var systemImageName: String {
		switch self {
		case .file: return "doc"
		case .image: return "photo"
		case .video: return "video"
		case .url: return "link"
		}
	}
	
	var name: String {
		switch self {
		case .file: return "Files"
		case .image: return "Images"
		case .video: return "Videos"
		case .url: return "Websites"
		}
	}
	
	static var all: [StoredItem.DataType] = [.file, .image, .video]
}
