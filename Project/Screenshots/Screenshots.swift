//
//  Screenshots.swift
//  Screenshots
//
//  Created by Emilio Peláez on 24/4/21.
//

import XCTest

class Screenshots: XCTestCase {
	
	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	override func tearDownWithError() throws {
	}
	
	func testPasscode() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content"]
		app.launch()
	}
	
	func testImport() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content", "Demo Skip Passcode", "Demo Import"]
		app.launch()
	}
	
	func testTags() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content", "Demo Skip Passcode", "Demo Tags"]
		app.launch()
	}
	
	func testDarkMode() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content", "Demo Skip Passcode", "Demo Override Dark Mode"]
		app.launch()
	}
}
