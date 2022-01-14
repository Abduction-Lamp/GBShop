//
//  MockProductRequest.swift
//  GBShopTests
//
//  Created by Владимир on 14.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop

// MARK: - ProductRequestFactory
//
class MockProductRequest: ProductRequestFactory {
    
    // MARK: CATALOG
    let catalogResponse = CatalogResponse(result: 1, message: "success", catalog: FakeData().catalog)
    
    lazy var catalogResultSuccess: Result<CatalogResponse, AFError> = .success(catalogResponse)
    lazy var catalogResultFailure: Result<CatalogResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var catalogResponseSuccess = AFDataResponse<CatalogResponse>(request: nil,
                                                                      response: nil,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: catalogResultSuccess)
    lazy var catalogResponseFailure = AFDataResponse<CatalogResponse>(request: nil,
                                                                      response: nil,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: catalogResultFailure)
    
    // MARK: getCatalog()
    func getCatalog(page: Int, completionHandler: @escaping (AFDataResponse<CatalogResponse>) -> Void) {
        if page >= 0 {
            completionHandler(catalogResponseSuccess)
        } else {
            completionHandler(catalogResponseFailure)
        }
    }
    
    
    // MARK: SECTION
    let sectionResponse = SectionResponse(result: 1, message: "success", section: FakeData().catalog[0])
    lazy var sectionResultSuccess: Result<SectionResponse, AFError> = .success(sectionResponse)
    lazy var sectionResultFailure: Result<SectionResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var sectionResponseSuccess = AFDataResponse<SectionResponse>(request: nil,
                                                                      response: nil,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: sectionResultSuccess)
    lazy var sectionResponseFailure = AFDataResponse<SectionResponse>(request: nil,
                                                                      response: nil,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: sectionResultFailure)
    
    // MARK: getSection()
    func getSection(id: Int, page: Int, completionHandler: @escaping (AFDataResponse<SectionResponse>) -> Void) {
        if id == 0 {
            completionHandler(sectionResponseSuccess)
        } else {
            completionHandler(sectionResponseFailure)
        }
    }
    
    
    // MARK: PRODUCT
    let productResponse = ProductResponse(result: 1, message: "success", product: FakeData().catalog[0].items[0])
    lazy var productResultSuccess: Result<ProductResponse, AFError> = .success(productResponse)
    lazy var productResultFailure: Result<ProductResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var productResponseSuccess = AFDataResponse<ProductResponse>(request: nil,
                                                                      response: nil,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: productResultSuccess)
    lazy var productResponseFailure = AFDataResponse<ProductResponse>(request: nil,
                                                                      response: nil,
                                                                      data: nil,
                                                                      metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: productResultFailure)

    // MARK: getProduct()
    func getProduct(id: Int, completionHandler: @escaping (AFDataResponse<ProductResponse>) -> Void) {
        if id == 0 {
            completionHandler(productResponseSuccess)
        } else {
            completionHandler(productResponseFailure)
        }
    }
}
