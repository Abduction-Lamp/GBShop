//
//  ColorExtensionTests.swift
//  GBShopTests
//
//  Created by Владимир on 24.12.2021.
//

import XCTest
@testable import GBShop

class ColorExtensionTests: XCTestCase {

    let subs: [UIColor] = [.red, .green, .blue]
    let colors: [UIColor] = [
        UIColor(red: 255, green: 0, blue: 0, alpha: 1),
        UIColor(red: 0, green: 255, blue: 0, alpha: 1),
        UIColor(red: 0, green: 0, blue: 255, alpha: 1)
    ]
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {  }

    func testColorExtension() throws {
        XCTAssertEqual(colors[0], subs[0])
        XCTAssertEqual(colors[1], subs[1])
        XCTAssertEqual(colors[2], subs[2])
    }
    
    func testColorExtensionFailure() throws {
        XCTAssertEqual(colors[0], subs[0])
        XCTAssertEqual(colors[1], subs[1])
        XCTAssertEqual(colors[2], subs[2])
    }
}
