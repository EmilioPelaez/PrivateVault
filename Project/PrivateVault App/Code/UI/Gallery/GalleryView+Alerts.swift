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
			return Alert(
				title: Text("Camera Access"),
				message: Text("PrivateVault doesn't have access to use your camera, please update your privacy settings."),
				primaryButton: .default(
					Text("Settings"),
					action: {
						URL(string: UIApplication.openSettingsURLString).map { UIApplication.shared.open($0) }
					}
				),
				secondaryButton: .cancel()
			)
		case let .deleteItemConfirmation(item):
			return Alert(
				title: Text("Delete File"),
				message: Text("Are you sure you want to delete this item? This action can't be undone."),
				primaryButton: .destructive(Text("Delete"), action: { delete(item) }),
				secondaryButton: .cancel()
			)
		}
	}
}
