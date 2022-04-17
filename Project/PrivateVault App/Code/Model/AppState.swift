//
//  AppState.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 24/09/2021.
//

import Combine

class AppState: ObservableObject {
	@Published var isLocked = !demoSkipPasscode
	
	@Published var currentFolder: Folder?
	
	@Published var attemptedToShowReviewPrompt = false
}
