//
//  AsynchronousOperation.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import Foundation

public class AsynchronousOperation: Operation, @unchecked Sendable {
	
	public let operation: (@escaping () -> Void) -> Void
	
	override public var isAsynchronous: Bool { true }
	override public var isExecuting: Bool { state == .executing }
	override public var isFinished: Bool { state == .finished }
	
	public init(block: @escaping (@escaping () -> Void) -> Void) {
		self.operation = block
		super.init()
		self.state = .ready
	}
	
	public override func main() {
		func finish() {
			state = .finished
		}
		state = .executing
		operation(finish)
	}
	
	public enum State: String {
		case ready = "Ready"
		case executing = "Executing"
		case finished = "Finished"
		fileprivate var keyPath: String { "is" + rawValue }
	}
	
	/// Thread-safe computed state value
	public var state: State {
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
