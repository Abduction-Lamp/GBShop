//
//  ProductRequest.swift
//  GBShop
//
//  Created by Владимир on 06.12.2021.
//

import Foundation
import Alamofire

class ProductRequest: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: Session
    var queue: DispatchQueue
    let baseUrl = URL(string: "https://salty-springs-77873.herokuapp.com/")!

    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension ProductRequest: ProductRequestFactory {

    func getCatalog(page: Int, completionHandler: @escaping (AFDataResponse<CatalogResponse>) -> Void) {
        let requestModel = Catalog(baseUrl: baseUrl, page: page)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func getSection(id: Int, page: Int, completionHandler: @escaping (AFDataResponse<SectionResponse>) -> Void) {
        let requestModel = SectionItem(baseUrl: baseUrl, id: id, page: page)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func getProduct(id: Int, completionHandler: @escaping (AFDataResponse<ProductResponse>) -> Void) {
        let requestModel = ProductItem(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension ProductRequest {

    struct Catalog: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        var path: String = "catalog"
        var parameters: Parameters?

        init(baseUrl: URL, page: Int) {
            self.baseUrl = baseUrl
            self.path += "/\(page)/"
        }
    }
    
    struct SectionItem: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        var path: String = "catalog/section"
        var parameters: Parameters?

        init(baseUrl: URL, id: Int, page: Int) {
            self.baseUrl = baseUrl
            self.path += "/\(id)/\(page)/"
        }
    }
    
    struct ProductItem: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        var path: String = "catalog/product"
        var parameters: Parameters?

        init(baseUrl: URL, id: Int) {
            self.baseUrl = baseUrl
            self.path += "/\(id)/"
        }
    }
}
