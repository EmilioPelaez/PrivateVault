//
//  EnvironmentMapper.swift
//  SharedUI
//
//  Created by Emilio Peláez on 03/04/22.
//

import SwiftUI

struct EnvironmentMapper<Source, Destination>: ViewModifier {
	let sourceKeyPath: WritableKeyPath<EnvironmentValues, Source>
	let destinationKeyPath: WritableKeyPath<EnvironmentValues, Destination>
	
	@State var output: Destination
	
	let transform: (Source) -> Destination
	
	init(source: WritableKeyPath<EnvironmentValues, Source>, destination: WritableKeyPath<EnvironmentValues, Destination>, defaultValue: Destination, transform: @escaping (Source) -> Destination) {
		self.sourceKeyPath = source
		self.destinationKeyPath = destination
		self._output = .init(initialValue: defaultValue)
		self.transform = transform
	}
	
	func body(content: Content) -> some View {
		content
			.transformEnvironment(sourceKeyPath) {
				output = transform($0)
			}
			.environment(destinationKeyPath, output)
	}
}
