//
//  CartRequest.swift
//  GBShop
//
//  Created by Владимир on 16.12.2021.
//

import Foundation
import Alamofire

class CartRequest: AbstractRequestFactory {
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

extension CartRequest: CartRequestFactory {
    
    func cart(owner: Int,
              token: String,
              completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        let requestModel = UserCart(baseUrl: baseUrl, owner: owner, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func addProduct(productId: Int,
                    owner: Int,
                    token: String,
                    completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        let requestModel = ProductAddToCart(baseUrl: baseUrl, productId: productId, owner: owner, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func deleteProduct(productId: Int,
                       owner: Int,
                       token: String,
                       completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        let requestModel = ProductDeleteFromCart(baseUrl: baseUrl, productId: productId, owner: owner, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func deleteAllByProduct(productId: Int,
                            owner: Int,
                            token: String,
                            completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        let requestModel = AllByProductDeleteFromCart(baseUrl: baseUrl, productId: productId, owner: owner, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func deleteAll(owner: Int,
                   token: String,
                   completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        let requestModel = AllDeleteFromCart(baseUrl: baseUrl, owner: owner, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func pay(owner: Int,
             token: String,
             completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        let requestModel = CartPay(baseUrl: baseUrl, owner: owner, token: token)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension CartRequest {
    
    struct UserCart: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "cart"
        let owner: Int
        let token: String
        var parameters: Parameters? {
            return [
                "owner": owner,
                "token": token
            ]
        }
    }
    
    struct ProductAddToCart: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "cart/add"
        let productId: Int
        let owner: Int
        let token: String
        var parameters: Parameters? {
            return [
                "product_id": productId,
                "owner": owner,
                "token": token
            ]
        }

    }
    
    struct ProductDeleteFromCart: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "cart/delete/product"
        let productId: Int
        let owner: Int
        let token: String
        var parameters: Parameters? {
            return [
                "product_id": productId,
                "owner": owner,
                "token": token
            ]
        }
    }
    
    struct AllByProductDeleteFromCart: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "cart/delete/product/all"
        let productId: Int
        let owner: Int
        let token: String
        var parameters: Parameters? {
            return [
                "product_id": productId,
                "owner": owner,
                "token": token
            ]
        }
    }
    
    struct AllDeleteFromCart: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "cart/delete/all"
        let owner: Int
        let token: String
        var parameters: Parameters? {
            return [
                "owner": owner,
                "token": token
            ]
        }
    }
    
    struct CartPay: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "cart/pay"
        let owner: Int
        let token: String
        var parameters: Parameters? {
            return [
                "owner": owner,
                "token": token
            ]
        }
    }
}
