//
//  ActionViewController.swift
//  PrivateVault Import Action
//
//  Created by Emilio Peláez on 15/3/21.
//

import Combine
import MobileCoreServices
import UIKit

class ActionViewController: UIViewController {
	
	enum ActionError: Error {
		case failure
	}
	
	@IBOutlet private weak var label: UILabel!
	@IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
	
	private var persistence: PersistenceManager?
	private var providers: [NSItemProvider] = []
	
	private var bag: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let context = extensionContext else { return }
		
		let items = context.inputItems.compactMap { $0 as? NSExtensionItem }
		let providers = items.flatMap { $0.attachments ?? [] }
		self.providers = providers
		
		label.text = "Importing \(providers.count) file(s)"
		activityIndicator.startAnimating()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard !providers.isEmpty else {
			extensionContext?.cancelRequest(withError: ActionError.failure)
			return
		}
		let persistence = PersistenceManager(iCloud: false)
		persistence.receiveItems(providers)
		persistence.$creatingFiles
			.filter { !$0 }
			.dropFirst()
			.map { _ in }
			.sink { [weak self] in self?.didComplete() }
			.store(in: &bag)
		
		self.persistence = persistence
	}
	
	private func didComplete() {
		extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
	}
}
