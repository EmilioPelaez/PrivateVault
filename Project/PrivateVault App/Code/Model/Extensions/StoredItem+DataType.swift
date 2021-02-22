//
//  StoredItem+DataType.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

import Foundation

extension StoredItem {
	enum DataType: Int16 {
		case unknown
		case image
	}

	var dataType: DataType {
		get { DataType(rawValue: dataTypeValue) ?? .unknown }
		set { dataTypeValue = newValue.rawValue }
	}
}
