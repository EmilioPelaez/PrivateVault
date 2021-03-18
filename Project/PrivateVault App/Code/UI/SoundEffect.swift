//
//  SoundEffect.swift
//  PrivateVault
//
//  Created by Daniel Behar on 2/20/21.
//

import AudioToolbox

enum SoundEffect {
	case success
	case failure
	case tap
	case open
	case close
	case openLong
	case closeLong
	
	var fileName: String {
		switch self {
		case .success: return "Success"
		case .failure: return "Denied"
		case .tap: return "Tap"
		case .open: return "Open"
		case .close: return "Close"
		case .openLong: return "OpenLong"
		case .closeLong: return "CloseLong"
		}
	}
	
	private static var soundIds: [SoundEffect: SystemSoundID] = [:]
	
	func play() {
		AudioServicesPlaySystemSound(soundId())
	}
	
	private func soundId() -> SystemSoundID {
		if let id = SoundEffect.soundIds[self] {
			return id
		}
		var id: SystemSoundID = 0
		defer { SoundEffect.soundIds[self] = id }
		guard let url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fileName as CFString, "wav" as CFString, nil) else { return id }
		AudioServicesCreateSystemSoundID(url, &id)
		return id
	}
}
