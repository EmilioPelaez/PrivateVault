//
//  AppState.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 24/09/2021.
//

import Combine
import Persistence
import Shared

public class AppState: ObservableObject {
	@Published public var isLocked = !demoSkipPasscode
	
	@Published public var currentFolder: Folder?
	
	@Published public var attemptedToShowReviewPrompt = false
	
	public init() {}
}
