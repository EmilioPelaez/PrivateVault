//
//  Events.swift
//  LockScreen
//
//  Created by Emilio Peláez on 31/03/22.
//

import HierarchyResponder

public struct LockEvent: Event {
	public init() {}
}
public struct UnlockEvent: Event {
	public init() {}
}

struct KeyDownEvent: Event {
	let value: String
}
struct KeypadDeleteEvent: Event {}

public struct PasscodeSetEvent: Event {
	public let passcode: String
}
struct PasscodeLengthSetEvent: Event {
	let length: Int
}
