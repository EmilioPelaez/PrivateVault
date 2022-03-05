//
//  SortMethod.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 12/3/21.
//

import Foundation

enum SortMethod: Int, CaseIterable, Identifiable {
	var id: Int { rawValue }
	
	case alphabeticalAscending
	case chronologicalDescending
	case dataType
	
	func apply(lhs: StoredItem, rhs: StoredItem) -> Bool {
		switch self {
		case .alphabeticalAscending:
			return (lhs.name ?? "").localizedStandardCompare(rhs.name ?? "") == .orderedAscending
		case .chronologicalDescending:
			return lhs.timestamp ?? .distantFuture > rhs.timestamp ?? .distantFuture
		case .dataType:
			return lhs.dataType.index < rhs.dataType.index
		}
	}
	
	func apply(lhs: Folder, rhs: Folder) -> Bool {
		(lhs.name ?? "").localizedStandardCompare(rhs.name ?? "") == .orderedAscending
	}
}

extension SortMethod: CustomStringConvertible {
	var description: String {
		switch self {
		case .alphabeticalAscending: return "Name"
		case .chronologicalDescending: return "Date"
		case .dataType: return "Kind"
		}
	}
	
	var systemImageName: String {
		switch self {
		case .alphabeticalAscending: return "text.cursor"
		case .chronologicalDescending: return "calendar"
		case .dataType: return "doc.richtext"
		}
	}
}
