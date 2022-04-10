//
//  AsynchronousOperation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import Foundation

class AsynchronousOperation: Operation {
	
	let operation: (@escaping () -> Void) -> Void
	
	override var isAsynchronous: Bool { true }
	override var isExecuting: Bool { state == .executing }
	override var isFinished: Bool { state == .finished }
	
	init(block: @escaping (@escaping () -> Void) -> Void) {
		self.operation = block
		super.init()
		self.state = .ready
	}
	
	override func main() {
		func finish() {
			state = .finished
		}
		state = .executing
		operation(finish)
	}
	
	enum State: String {
		case ready = "Ready"
		case executing = "Executing"
		case finished = "Finished"
		fileprivate var keyPath: String { "is" + rawValue }
	}
	
	/// Thread-safe computed state value
	var state: State {
		get {
			stateQueue.sync { stateStore }
		}
		set {
			let oldValue = state
			willChangeValue(forKey: state.keyPath)
			willChangeValue(forKey: newValue.keyPath)
			stateQueue.sync(flags: .barrier) { stateStore = newValue }
			didChangeValue(forKey: state.keyPath)
			didChangeValue(forKey: oldValue.keyPath)
		}
	}
	
	private let stateQueue = DispatchQueue(label: "AsynchronousOperationStateQueue", attributes: .concurrent)
	
	// Non thread-safe state storage, use only with locks
	private var stateStore: State = .ready
	
}
