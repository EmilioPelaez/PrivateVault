//
//  ActionViewController.swift
//  PrivateVault Import Action
//
//  Created by Emilio Peláez on 15/3/21.
//

import Combine
import UIKit
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
	
	enum ActionError: Error {
		case failure
	}
	
	@IBOutlet private var importingContainer: UIView!
	@IBOutlet private var importingLabel: UILabel!
	@IBOutlet private var activityIndicator: UIActivityIndicatorView!
	
	@IBOutlet private var failureContainer: UIView!
	
	@IBOutlet private var closeButton: UIButton!
	
	private var persistence: PersistenceManager?
	private var providers: [NSItemProvider] = []
	
	private var bag: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let context = extensionContext else {
			importingContainer.isHidden = true
			failureContainer.isHidden = false
			closeButton.isHidden = false
			return
		}
		
		importingContainer.isHidden = false
		failureContainer.isHidden = true
		closeButton.isHidden = true
		
		let providers = context.inputItems
			.compactMap { $0 as? NSExtensionItem }
			.flatMap { $0.attachments ?? [] }
			.filter {
				$0.registeredTypeIdentifiers.compactMap(UTType.init).contains {
					$0.isSupported
				}
			}
		self.providers = providers
		
		importingLabel.text = "Importing \(providers.count) file(s)"
		activityIndicator.startAnimating()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard !providers.isEmpty else { return }
		let persistence = PersistenceManager(iCloud: false, operationLimit: 1)
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
		UIView.animate(withDuration: 0.25) {
			self.activityIndicator.stopAnimating()
			self.importingLabel.text = "Import Complete!"
			self.closeButton.isHidden = false
		}
	}
	
	@IBAction func close() {
		extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
	}
}
