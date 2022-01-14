//
//  MockNetwork.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop


// MARK: - MockNetworkRequest
//
class MockNetworkRequest: RequestFactoryProtocol {
    
    func makeAuthRequestFactory() -> AuthRequestFactory {
        return MockNetworkAuthRequest()
    }
    func makeUserRequestFactory() -> UserRequestFactory {
        return MockNetworkUserRequest()
    }
    func makeProductRequestFactory() -> ProductRequestFactory {
        return MockProductRequest()
    }
    func makeCartRequestFactory() -> CartRequestFactory {
        return MockCartRequestFactory()
    }
    func makeReviewRequestFactory() -> ReviewRequestFactory {
        return MockNetworkReviewRequest()
    }
}
