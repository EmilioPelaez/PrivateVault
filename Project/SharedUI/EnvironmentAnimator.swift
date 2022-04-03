//
//  EnvironmentAnimator.swift
//  TansitionTest
//
//  Created by Emilio Peláez on 20/03/22.
//

import SwiftUI

struct EnvironmentAnimator<Value: Equatable>: ViewModifier {
	let keyPath: WritableKeyPath<EnvironmentValues, Value>
	@Environment var input: Value
	@State var output: Value
	
	init(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, defaultValue: Value) {
		self.keyPath = keyPath
		_input = .init(keyPath)
		_output = .init(initialValue: defaultValue)
	}

	func body(content: Content) -> some View {
		content
			.onAppear {
				output = input
			}
			.onChange(of: input) { newValue in
				withAnimation {
					output = newValue
				}
			}
			.environment(keyPath, output)
	}
}

public extension View {
	func animateEnvironment<Key: EnvironmentKey>(_ path: WritableKeyPath<EnvironmentValues, Key.Value>, key: Key.Type) -> some View where Key.Value: Equatable {
		modifier(EnvironmentAnimator(path, defaultValue: Key.defaultValue))
	}
	
	func animateEnvironment<Value: Equatable>(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, defaultValue: Value) -> some View {
		modifier(EnvironmentAnimator(keyPath, defaultValue: defaultValue))
	}
	
	func animateEnvironment(_ keyPath: WritableKeyPath<EnvironmentValues, Bool>) -> some View {
		modifier(EnvironmentAnimator(keyPath, defaultValue: true))
	}
	
	func animateEnvironment(_ keyPath: WritableKeyPath<EnvironmentValues, Int>) -> some View {
		modifier(EnvironmentAnimator(keyPath, defaultValue: 0))
	}
	
	func animateEnvironment(_ keyPath: WritableKeyPath<EnvironmentValues, Double>) -> some View {
		modifier(EnvironmentAnimator(keyPath, defaultValue: 0))
	}
	
	func animateEnvironment(_ keyPath: WritableKeyPath<EnvironmentValues, Float>) -> some View {
		modifier(EnvironmentAnimator(keyPath, defaultValue: 0))
	}
	
	func animateEnvironment<T: Equatable>(_ keyPath: WritableKeyPath<EnvironmentValues, [T]>) -> some View {
		modifier(EnvironmentAnimator(keyPath, defaultValue: []))
	}
}
