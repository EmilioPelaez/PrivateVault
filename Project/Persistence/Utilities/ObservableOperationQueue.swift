//
//  ObservableOperationQueue.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/2/21.
//

import Combine
import Foundation

class ObservableOperationQueue: OperationQueue {
	
	@Published var isRunning = false
	
	private var token: Any?
	
	override init() {
		super.init()
		
		self.token = observe(\.operations, options: [.old, .new]) { [weak self] _, change in
			guard let self = self else { return }
			guard let newValue = change.newValue, newValue != change.oldValue else { return }
			DispatchQueue.main.async {
				self.isRunning = !newValue.isEmpty
			}
		}
	}
	
}
