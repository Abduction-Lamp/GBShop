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
        
    }
    
    func getGoodById(id: Int, completionHandler: @escaping (AFDataResponse<GetGoodByIdResult>) -> Void) {
        
    }
}

extension ProductRequest {
    
}
