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
    
    let baseUrl = URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: Session,
         queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension ProductRequest: ProductRequestFactory {
    
    func getCatalog(id: Int, page: Int, completionHandler: @escaping (AFDataResponse<[Product]>) -> Void) {
        let requestModel = Catalog(baseUrl: baseUrl, id: id, page: page)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func getGoodById(id: Int, completionHandler: @escaping (AFDataResponse<GetGoodByIdResult>) -> Void) {
        let requestModel = GoodById(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension ProductRequest {
    
    struct Catalog: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "catalogData.json"
        let id: Int
        let page: Int
        var parameters: Parameters? {
            return [
                "id_category": id,
                "page_numbe" : page
            ]
        }
    }
    
    struct GoodById: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "getGoodById.json"
        let id: Int
        var parameters: Parameters? {
            return [
                "id_product": id
            ]
        }
    }
}
