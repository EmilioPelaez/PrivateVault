//
//  StoredItem+Example.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 20/2/21.
//

public extension StoredItem {
	static let example: StoredItem = {
		PreviewEnvironment().item
	}()
}
