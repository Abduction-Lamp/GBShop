//
//  ProductResponseCodableTests.swift
//  GBShopTests
//
//  Created by Владимир on 06.12.2021.
//

import Foundation


import XCTest
import Alamofire
@testable import GBShop

class ProductResponseCodableTests: XCTestCase {

    let resultStub: [Product] = [
        Product(id: 123, name: "Ноутбук", price: 45600, description: nil),
        Product(id: 456, name: "Мышка", price: 1000, description: nil)
    ]
    let expressionProductStub: GetGoodByIdResult = GetGoodByIdResult(result: 1, name: "Ноутбук", price: 45600, description: "Мощный игровой ноутбук")
    
    let productRequest = RequestFactory().makeProductRequestFactory()
    
    let expectation = XCTestExpectation(description: "Download https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")
    
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    
    func testGetCatalogResult() throws {
        productRequest.getCatalog(id: 1, page: 1) { result in
            switch result.result {
            case .success(let catalog):
                if catalog.count == self.resultStub.count {
                    for i in 0 ..< catalog.count {
                        XCTAssertEqual(catalog[i].id, self.resultStub[i].id)
                        XCTAssertEqual(catalog[i].name, self.resultStub[i].name)
                        XCTAssertEqual(catalog[i].price, self.resultStub[i].price)
                        XCTAssertEqual(catalog[i].description, self.resultStub[i].description)
                    }
                } else {
                    XCTFail("catalogs don't match in count")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testGetGoodByIdResult() throws {
        productRequest.getGoodById(id: 123) { result in
            switch result.result {
            case .success(let product):
                XCTAssertEqual(product.result, self.expressionProductStub.result)
                XCTAssertEqual(product.name, self.expressionProductStub.name)
                XCTAssertEqual(product.price, self.expressionProductStub.price)
                XCTAssertEqual(product.description, self.expressionProductStub.description)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
