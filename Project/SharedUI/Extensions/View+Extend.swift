//
//  View+Extend.swift
//  SharedUI
//
//  Created by Emilio Peláez on 30/03/22.
//

import SwiftUI

public extension View {
	
	func extendHorizontally(alignment: HorizontalAlignment = .center) -> some View {
		frame(maxWidth: .infinity, alignment: alignment.general)
	}
	
	func extendVertically(alignment: VerticalAlignment = .center) -> some View {
		frame(maxHeight: .infinity, alignment: alignment.general)
	}
	
	func extend(alignment: Alignment = .center) -> some View {
		frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
	}
	
}

extension HorizontalAlignment {
	var general: Alignment {
		switch self {
		case .center: return .center
		case .trailing: return .leading
		case .leading: return .leading
		case _: return .center
		}
	}
}

extension VerticalAlignment {
	var general: Alignment {
		switch self {
		case .center: return .center
		case .top: return .top
		case .bottom: return .bottom
		case _: return .center
		}
	}
}
