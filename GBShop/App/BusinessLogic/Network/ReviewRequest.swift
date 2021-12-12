//
//  ReviewRequest.swift
//  GBShop
//
//  Created by Владимир on 12.12.2021.
//

import Foundation

import Foundation
import Alamofire

class ReviewRequest: AbstractRequestFactory {
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

extension ReviewRequest: ReviewRequestFactory {
    
    func reviewByProduct(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        let requestModel = ReviewByProduct(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func reviewByUser(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        let requestModel = ReviewByUser(baseUrl: baseUrl, id: id)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension ReviewRequest {
    
    struct ReviewByProduct: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        var path: String = "product"
        var parameters: Parameters? = nil
        
        init(baseUrl: URL, id: Int) {
            self.baseUrl = baseUrl
            self.path += "/\(id)/review/"
        }
    }
    
    struct ReviewByUser: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        var path: String = "user"
        var parameters: Parameters? = nil
        
        init(baseUrl: URL, id: Int) {
            self.baseUrl = baseUrl
            self.path += "/\(id)/review/"
        }
    }
}
