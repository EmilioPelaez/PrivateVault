//
//  View+Padding.swift
//  UISupport
//
//  Created by Emilio Peláez on 14/11/21.
//

import SwiftUI

public extension View {
	
	func smallPadding(_ edges: Edge.Set = .all) -> some View {
		padding(edges, .paddingSmall)
	}
	
	func mediumPadding(_ edges: Edge.Set = .all) -> some View {
		padding(edges, .paddingMedium)
	}
	
	func largePadding(_ edges: Edge.Set = .all) -> some View {
		padding(edges, .paddingLarge)
	}
	
}
