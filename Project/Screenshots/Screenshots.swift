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
		setupSnapshot(app)
		app.launch()
		
		snapshot("0_LockScreen")
	}
	
	func testImport() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content", "Demo Skip Passcode", "Demo Import"]
		setupSnapshot(app)
		app.launch()
		
		snapshot("1_Import")
	}
	
	func testTags() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content", "Demo Skip Passcode", "Demo Tags"]
		setupSnapshot(app)
		app.launch()
		
		snapshot("2_Tags")
	}
	
	func testDarkMode() throws {
		let app = XCUIApplication()
		app.launchArguments = ["Demo Content", "Demo Skip Passcode", "Demo Override Dark Mode"]
		setupSnapshot(app)
		app.launch()
		
		snapshot("3_DarkMode")
	}
}
