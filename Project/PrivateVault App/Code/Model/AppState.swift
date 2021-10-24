//
//  AppState.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 24/09/2021.
//

import Combine

class AppState: ObservableObject {
	@Published var isLocked = true
	
	@Published var currentFolder: Folder?
	
	@Published var attemptedToShowReviewPrompt = false
}
