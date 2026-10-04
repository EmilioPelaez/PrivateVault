//
//  ImportError.swift
//  PrivateVault Import Action
//
//  Created by Emilio Peláez on 17/3/21.
//

import Foundation

public enum ImportError: Error {
	case livePhotoUnsupported
	case unsupportedFile
	case cantLoadImage
	case cantLoadVideo
	case cantLoadPDF
	case cantLoadURL
	case cantReadFile
	
	public var errorDescription: String {
		switch self {
		case .livePhotoUnsupported: return "Live Photos are not supported."
		case .unsupportedFile: return "Unsupported file."
		case .cantLoadImage: return "Unable to load image."
		case .cantLoadVideo: return "Unable to load video."
		case .cantLoadPDF: return "Unable to load PDF."
		case .cantLoadURL: return "Unable to load URL."
		case .cantReadFile: return "Unable to read file."
		}
	}
}

public extension Array where Element == ImportError {
	
	var displayMessage: String {
		Set(map(\.errorDescription)).joined(separator: "\n")
	}
	
}
