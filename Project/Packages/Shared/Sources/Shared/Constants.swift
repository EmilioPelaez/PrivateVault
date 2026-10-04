//
//  Constants.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 24/4/21.
//

import Foundation

public var demoContent: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Content")
	#else
	return false
	#endif
}

public var demoOverrideDarkMode: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Override Dark Mode")
	#else
	return false
	#endif
}

public var demoSkipPasscode: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Skip Passcode")
	#else
	return false
	#endif
}

public var demoImport: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Import")
	#else
	return false
	#endif
}

public var demoFolders: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Folders")
	#else
	return false
	#endif
}

public var demoTags: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Tags")
	#else
	return false
	#endif
}
