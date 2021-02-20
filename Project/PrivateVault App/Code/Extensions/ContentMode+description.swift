//
//  ContentMode+description.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

extension ContentMode: CustomStringConvertible {
	public var description: String {
		switch self {
		case .fill: return "Fill"
		case .fit: return "Fit"
		}
	}
}
