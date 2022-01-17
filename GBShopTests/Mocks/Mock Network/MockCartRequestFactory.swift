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
    let cartAddResponse = CartResponse(result: 1, message: "success", cart: FakeData().cartPlusOneProduct.items)
    let cartDeleteResponse = CartResponse(result: 1, message: "success", cart: FakeData().cartMinusOneProduct.items)
    let cartEmptyResponse = CartResponse(result: 1, message: "success", cart: Cart().items)
    
    lazy var cartResultSuccess: Result<CartResponse, AFError> = .success(cartResponse)
    lazy var cartAddResultSuccess: Result<CartResponse, AFError> = .success(cartAddResponse)
    lazy var cartDeleteResultSuccess: Result<CartResponse, AFError> = .success(cartDeleteResponse)
    lazy var cartEmptyResultSuccess: Result<CartResponse, AFError> = .success(cartEmptyResponse)

    lazy var cartResultFailure: Result<CartResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var cartResponseSuccess = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartResultSuccess)
    lazy var cartAddResponseSuccess = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartAddResultSuccess)
    lazy var cartDeleteResponseSuccess = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartDeleteResultSuccess)
    lazy var cartDeleteAllResponseSuccess = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartEmptyResultSuccess)
    lazy var cartBuyAllResponseSuccess = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartEmptyResultSuccess)
    lazy var cartResponseFailure = AFDataResponse<CartResponse>(request: nil,
                                                                response: nil,
                                                                data: nil,
                                                                metrics: nil,
                                                                serializationDuration: 1,
                                                                result: cartResultFailure)
    
    func cart(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func addProduct(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartAddResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func deleteProduct(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartDeleteResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func deleteAllByProduct(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartDeleteResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func deleteAll(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartDeleteAllResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func pay(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartBuyAllResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
}
