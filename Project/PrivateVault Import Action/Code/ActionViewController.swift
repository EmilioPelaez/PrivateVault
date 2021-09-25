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
	@IBOutlet private var errorButton: UIButton!
	
	private var persistence: PersistenceManager?
	private var providers: [NSItemProvider] = []
	private var errors: [ImportError] = []
	
	private var bag: Set<AnyCancellable> = []
	var folder: Folder?
	
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
		errorButton.isHidden = true
		
		let providers = context.inputItems
			.compactMap { $0 as? NSExtensionItem }
			.flatMap { $0.attachments ?? [] }
		self.providers = providers
		
		guard !providers.isEmpty else { return }
		
		if providers.count == 1 {
			importingLabel.text = "Importing 1 File"
		} else {
			importingLabel.text = "Importing \(providers.count) Files"
		}
		activityIndicator.startAnimating()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard !providers.isEmpty else { return }
		let persistence = PersistenceManager(usage: .importExtension)
		persistence.receiveItems(providers, folder: folder)
		persistence.$creatingFiles
			.filter { !$0 }
			.dropFirst()
			.map { _ in }
			.sink { [weak self] in self?.didComplete() }
			.store(in: &bag)
		
		self.persistence = persistence
	}
	
	private func didComplete() {
		UIView.animate(withDuration: 0.25) { [self] in
			activityIndicator.stopAnimating()
			let errorCount = persistence?.importErrors.count ?? 0
			switch errorCount {
			case 0: importingLabel.text = "Import Complete!"
			case 0..<providers.count: importingLabel.text = "Import finished with \(errorCount) errors."
			case _: importingLabel.text = "Import Failed..."
			}
			closeButton.isHidden = false
			errorButton.isHidden = errorCount == 0
		}
	}
	
	@IBAction func close() {
		extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
	}
	
	@IBAction func showErrors() {
		guard let errors = persistence?.importErrors, !errors.isEmpty else { return }
		let alert = UIAlertController(title: errors.count == 1 ? "Error" : "Errors", message: errors.displayMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default))
		present(alert, animated: true)
	}
}
