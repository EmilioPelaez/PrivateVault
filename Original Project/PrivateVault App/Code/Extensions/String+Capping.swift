//
//  String+Capping.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

extension String {
	func capping(_ maxLength: Int) -> String {
		if count <= maxLength {
			return self
		} else {
			return prefix(maxLength - 3) + "..."
		}
	}
}
