//
//  MockCartRequestFactory.swift
//  GBShopTests
//
//  Created by Владимир on 14.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop


// MARK: - MockCartRequestFactory
//
class MockCartRequestFactory: CartRequestFactory {
    let fake = FakeData()
    
    let cartResponse = CartResponse(result: 1, message: "success", cart: FakeData().cart.items)
    
    lazy var cartResultSuccess: Result<CartResponse, AFError> = .success(cartResponse)
    lazy var cartResultFailure: Result<CartResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var cartResponseSuccess = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartResultSuccess)
    lazy var cartResponseFailure = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartResultFailure)
    
    func cart(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        return
    }
    
    func addProduct(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func deleteProduct(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func deleteAllByProduct(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func deleteAll(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func pay(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        return
    }
}
