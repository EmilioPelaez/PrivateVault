//
//  UserSettings.swift
//  PrivateVault
//
//  Created by Ian Manor on 20/02/21.
//

import SwiftUI

final class UserSettings: ObservableObject {
	@Published var contentMode: ContentMode = .fill
	@Published var showDetails = true
	@Published var password = "1234"
	@Published var maxAttempts = 5
}
