//
//  LinkType.swift
//  PrivateVault
//
//  Created by Ian Manor on 21/02/21.
//

import SwiftUI

enum LinkType {
	case twitter(String)
	case website(String)
	case appStore(String)
	case github(String)

	var systemName: String {
		switch self {
		case .twitter: return "message.fill"
		case .website: return "globe"
		case .appStore: return "apps.iphone"
		case .github: return "chevron.left.slash.chevron.right"
		}
	}

	var color: Color {
		switch self {
		case .twitter: return Color(red: 0.11, green: 0.63, blue: 0.95)
		case .website: return .blue
		case .appStore, .github: return .black
		}
	}

	var size: CGFloat {
		switch self {
		case .twitter: return 18
		case .website: return 28
		case .appStore: return 22
		case .github: return 14
		}
	}

	var urlString: String {
		switch self {
		case let .twitter(urlString): return urlString
		case let .website(urlString): return urlString
		case let .appStore(urlString): return urlString
		case let .github(urlString): return urlString
		}
	}
}
