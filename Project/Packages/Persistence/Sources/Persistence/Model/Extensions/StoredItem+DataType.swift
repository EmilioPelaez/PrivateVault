//
//  StoredItem+DataType.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

public extension StoredItem {
	enum DataType: Int16, Identifiable, CaseIterable {
		case file
		case image
		case video
		case url
		
		public var id: Int16 { rawValue }
		
		public var index: Int {
			DataType.allCases.firstIndex(of: self) ?? DataType.allCases.count
		}
	}

	var dataType: DataType {
		get { DataType(rawValue: dataTypeValue) ?? .file }
		set { dataTypeValue = newValue.rawValue }
	}
}

public extension StoredItem.DataType {
	var systemImageName: String {
		switch self {
		case .file: return "doc"
		case .image: return "photo"
		case .video: return "video"
		case .url: return "link"
		}
	}
	
	var overlaySystemImageName: String {
		switch self {
		case .file: return "doc"
		case .image: return "photo"
		case .video: return "play.fill"
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
}
