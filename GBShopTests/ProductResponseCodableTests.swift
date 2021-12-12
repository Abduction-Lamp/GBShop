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
    
    let request = RequestFactory().makeProductRequestFactory()
    let expectation = XCTestExpectation(description: "Download https://salty-springs-77873.herokuapp.com/")

    
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    
    
    // MARK: - Product
    //
    func testProductResponseSuccess() throws {
        let expression = ProductResponse (result: 1,
                                          message: "Success",
                                          product: Product(id: 1,
                                                           name: "MacBook Pro",
                                                           category: "Ноутбук",
                                                           price: 250_000,
                                                           description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ"))
        request.getProduct(id: 1) { response in
            switch response.result {
            case .success(let product):
                XCTAssertEqual(product.result, expression.result)
                XCTAssertEqual(product.message, expression.message)
                XCTAssertEqual(product.product, expression.product)

            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testProductResponseFailure() throws {
        let expression = ProductResponse(result: 0, message: "Failure", product: nil)
        
        request.getProduct(id: 7) { response in
            switch response.result {
            case .success(let product):
                XCTAssertEqual(product.result, expression.result)
                XCTAssertEqual(product.message, expression.message)
                XCTAssertEqual(product.product, expression.product)

            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    
    // MARK: - Catalog
    //
    func testCatalogResponseSuccess() throws {
        let expression = CatalogResponse(result: 1,
                                         message: "Цисло товаров = 3",
                                         catalog: [
                                            Product(id: 3,
                                                    name: "PlayStation 5",
                                                    category: "Игровая приставка",
                                                    price: 90_003,
                                                    description: "825 ГБ SSD, белый"),
                                            Product(id: 4,
                                                    name: "PlayStation 4 Slim",
                                                    category: "Игровая приставка",
                                                    price: 44_500,
                                                    description: "500 ГБ HDD, черный"),
                                            Product(id: 5,
                                                    name: "XBox Series X",
                                                    category: "Игровая приставка",
                                                    price: 69_770,
                                                    description: "1000 ГБ SSD, черный")
                                         ])
        request.getCatalog(id: 2, page: 1) { response in
            switch response.result {
            case .success(let catalog):
                XCTAssertEqual(catalog.result, expression.result)
                XCTAssertEqual(catalog.message, expression.message)
                if let resultCatalog = catalog.catalog,
                   let expressionCatalog = expression.catalog,
                   resultCatalog.count == expressionCatalog.count {
                    for index in 0 ..< resultCatalog.count {
                        XCTAssertEqual(resultCatalog[index], expressionCatalog[index])
                    }
                } else {
                    XCTFail("Размер каталогов не совпадают [\(catalog.catalog?.count ?? 0) != \(expression.catalog?.count ?? 0)]")
                }

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testCatalogResponseFailure() throws {
        let expression: CatalogResponse = CatalogResponse(result: 0, message: "Каталог пуст", catalog: nil)
    
        request.getCatalog(id: 11, page: 1) { response in
            switch response.result {
            case .success(let catalog):
                XCTAssertEqual(catalog.result, expression.result)
                XCTAssertEqual(catalog.message, expression.message)
                XCTAssertEqual(catalog.catalog, expression.catalog)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
