//
//  BiometricsState.swift
//  Shared
//
//  Created by Emilio Peláez on 03/04/22.
//

import Foundation

public struct BiometricsState {
	public let name: String
	public let imageName: String
	public let available: Bool
}

public extension BiometricsState {
	static let none: BiometricsState = BiometricsState(name: "", imageName: "questionmark.circle", available: false)
	static let faceID = BiometricsState(name: "FaceID", imageName: "faceid", available: true)
	static let touchID = BiometricsState(name: "TouchID", imageName: "touchid", available: true)
}
