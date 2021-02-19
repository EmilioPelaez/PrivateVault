//
//  Navigation.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/19/21.
//

import SwiftUI

struct Navigation: View {
	var body: some View {
		NavigationView {
			GalleryView()
				.navigationTitle("Gallery")
		}
	}
}

struct Navigation_Previews: PreviewProvider {
	static var previews: some View {
		Navigation()
	}
}
