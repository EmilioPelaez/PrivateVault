//
//  Events.swift
//  LockScreen
//
//  Created by Emilio Peláez on 31/03/22.
//

import HierarchyResponder

public struct UnlockEvent: Event {}
struct KeyDownEvent: Event {
	let value: String
}
struct KeypadDeleteEvent: Event {}
