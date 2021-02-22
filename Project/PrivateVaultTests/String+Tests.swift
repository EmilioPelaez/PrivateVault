//
//  StringExtensionTests.swift
//  PrivateVaultTests
//
//  Created by Ian Manor on 21/02/21.
//

import XCTest

@testable import PrivateVault

class StringExtensionTests: XCTestCase {
	func testStringCapping() {
		XCTAssertEqual("123456".capping(5), "12...")
	}

	func testStringNotCapping() {
		XCTAssertEqual("123456".capping(10), "123456")
	}
}
