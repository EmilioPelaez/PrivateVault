//
//  Constants.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 24/4/21.
//

import Foundation

var demoContent: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Content")
	#else
	return false
	#endif
}

var demoOverrideDarkMode: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Override Dark Mode")
	#else
	return false
	#endif
}

var demoSkipPasscode: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Skip Passcode")
	#else
	return false
	#endif
}

var demoImport: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Import")
	#else
	return false
	#endif
}

var demoTags: Bool {
	#if targetEnvironment(simulator)
	return ProcessInfo.processInfo.arguments.contains("Demo Tags")
	#else
	return false
	#endif
}
