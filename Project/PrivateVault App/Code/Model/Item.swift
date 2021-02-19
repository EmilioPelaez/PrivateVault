//
//  Item.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct Item: Identifiable {
	var id: String = UUID().uuidString
	
	let color: Color
}

extension Item {
	init(color: Color) {
		self.color = color
	}
}
