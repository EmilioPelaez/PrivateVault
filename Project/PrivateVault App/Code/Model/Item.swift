//
//  Item.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 19/2/21.
//

import SwiftUI

struct Item: Identifiable {
	var id: String = UUID().uuidString
	
	let image: Image
}

extension Item {
	init(image: Image) {
		self.image = image
	}
}
