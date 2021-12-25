//
//  StringExtensionsValidCreditCardTests.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
@testable import GBShop

class StringExtensionsValidCreditCardTests: XCTestCase {

    let cardsSuccess: [String] = [
        "1234-1234-1234-1234",
        "0000-0000-0000-0000"
    ]

    let cardsFailure: [String] = [
        "",
        "OOOO-OOOO-OOOO-OOOO",
        "123-1234-1234-1234",
        "1234123412341234",
        "1234-1234-1234-1234-",
        "-1234-1234-1234-1234",
        "1234-1234-1234-1234-1234",
        "1234-1234-1234",
        "1234-1234-1234-abcd",
        "1234--1234--1234--1234",
        "1234 1234 1234 1234",
        "1111222233334444"
    ]
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testValidSuccessCards() throws {
        cardsSuccess.forEach { card in
            XCTAssertTrue(card.isValidCreditCard())
        }
    }
    
    func testValidFailureCards() throws {
        cardsFailure.forEach { card in
            XCTAssertFalse(card.isValidCreditCard())
        }
    }
}
