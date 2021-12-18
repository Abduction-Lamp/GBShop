//
//  ErrorParserTests.swift
//  GBShopTests
//
//  Created by Владимир on 05.12.2021.
//

import XCTest
@testable import GBShop

class ErrorParserTests: XCTestCase {

    enum ErrorStub: Error {
        case fatalError
        case сrushTest
    }
    let fakeError: ErrorStub = ErrorStub.fatalError
    
    var errorParser: ErrorParser?
    
    
    override func setUpWithError() throws {
        errorParser = ErrorParser()
    }

    override func tearDownWithError() throws {
        errorParser = nil
    }

    
    func testParseError() throws {
        if let result = (errorParser!.parse(fakeError) as? ErrorStub) {
            let exp = ErrorStub.fatalError
            XCTAssertEqual(result, exp)
        } else {
            XCTFail("Result does not match ErrorStub")
        }
    }
    
    func testParseErrorWithData() throws {
        if let result = (errorParser!.parse(response: nil, data: nil, error: fakeError) as? ErrorStub) {
            let exp = ErrorStub.fatalError
            XCTAssertEqual(result, exp)
        } else {
            XCTFail("Result does not match ErrorStub")
        }
    }
}
