//
//  View+SoundEffect.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import SwiftUI

extension View {

	func soundEffect(soundEffect: SoundEffect) -> some View {
		soundEffect.play()
		return self
	}
	
}
