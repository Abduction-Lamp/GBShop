//
//  StringExtensionsValidEmailTests.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
@testable import GBShop

class StringExtensionsValidEmailTests: XCTestCase {

    let emailSuccess: [String] = [
        "test@test.ru",
        "TEST@TEST.RU",
        "тест@тест.ру",
        "ТЕСТ@ТЕСТ.РУ",
        "123@123.com",
        "e@m.il",
        "test-123@test.ru",
        "t.e.s.t@test.ru"
    ]

    let emailFailure: [String] = [
        "",
        "TEST@.RU",
        "TESTtest.RU",
        "@тест.ру",
        "ТЕСТ@ТЕСТ.",
        "123@123com",
        "e@m.i",
        "test@123@test.ru",
        "123@123.123"
    ]

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testValidSuccessEmail() throws {
        emailSuccess.forEach { email in
            XCTAssertTrue(email.isValidEmail())
        }
    }
    
    func testValidFailureEmail() throws {
        emailFailure.forEach { email in
            XCTAssertFalse(email.isValidEmail())
        }
    }
}
