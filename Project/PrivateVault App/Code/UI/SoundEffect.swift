//
//  SoundEffect.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import AVFoundation

// swiftlint:disable number_separator
enum SoundEffect {
	case success
	case failure
	case tap
	case none
	
	var fileName: String? {
		switch self {
		case .success: return "Success.wav"
		case .failure: return "Denied.wav"
		case .tap: return "Tap.wav"
		case _: return nil
		}
	}
	
	static var player: AVAudioPlayer?
	
	func play() {
		guard let fileName = fileName else { return }
		guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
			return
		}
		do {
			try AVAudioSession.sharedInstance().setCategory(.ambient)
			try AVAudioSession.sharedInstance().setActive(true)
			
			let player = try AVAudioPlayer(contentsOf: url)
			player.play()
			SoundEffect.player = player
		} catch {
			print(error)
		}
	}
}
