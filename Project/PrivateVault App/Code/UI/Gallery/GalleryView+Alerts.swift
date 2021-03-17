//
//  GalleryView+Alerts.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 27/2/21.
//

import SwiftUI

extension GalleryView {
	func alert(currentAlert: AlertItem) -> Alert {
		switch currentAlert {
		case .showPermissionAlert:
			return Alert(title: Text("Camera Access"),
									 message: Text("PrivateVault doesn't have access to use your camera, please update your privacy settings."),
									 primaryButton: .default(Text("Settings"), action: {
										URL(string: UIApplication.openSettingsURLString).map { UIApplication.shared.open($0) }
									 }),
									 secondaryButton: .cancel()
			)
		case let .deleteItemConfirmation(item):
			return Alert(title: Text("Delete File"),
									 message: Text("Are you sure you want to delete this item? This action can't be undone."),
									 primaryButton: .destructive(Text("Delete"), action: { delete(item) }),
									 secondaryButton: .cancel())
		case let .deleteItemsConfirmation(items):
			return Alert(title: Text("Delete Files"),
									 message: Text("Are you sure you want to delete \(items.count) item? This action can't be undone."),
									 primaryButton: .destructive(Text("Delete"), action: { delete(items) }),
									 secondaryButton: .cancel())
		case .emptyClipboard:
			return Alert(title: Text("Empty Clipboard"),
									 message: Text("There are not items in your clipboard."),
									 dismissButton: .default(Text("Ok")))
		case .persistenceError(let string):
			return Alert(title: Text("Unable to Save Changes"),
									 message: Text(string),
									 dismissButton: .default(Text("Ok")))
		case .persistenceFatalError(let string):
			return Alert(title: Text("Fatal Error"),
									 message: Text("Unable to load database, the app might function correctly.\n" + string),
									 dismissButton: .default(Text("Ok")))
		case .importErrors(let errors):
			return Alert(title: errors.count == 1 ? Text("Error During Import") : Text("\(errors.count) Errors During Import"),
									 message: Text(errors.displayMessage),
									 dismissButton: .default(Text("Ok")))
		}
	}
}
