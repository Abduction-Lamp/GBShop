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


// MARK: - MockNetworkAuthRequest
//
class MockNetworkAuthRequest: AuthRequestFactory {
    
    let fake = FakeData()
    
    // MARK: LOGIN
    lazy var loginResponse = LoginResponse(result: 1, message: "success", user: fake.user, token: fake.token)
    lazy var loginResultSuccess: Result<LoginResponse, AFError> = .success(loginResponse)
    lazy var loginResultFailure: Result<LoginResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var loginResponseSuccess = AFDataResponse<LoginResponse>(request: nil,
                                                                  response: nil,
                                                                  data: nil,
                                                                  metrics: nil,
                                                                  serializationDuration: 1,
                                                                  result: loginResultSuccess)
    lazy var loginResponseFailure = AFDataResponse<LoginResponse>(request: nil,
                                                                  response: nil,
                                                                  data: nil,
                                                                  metrics: nil,
                                                                  serializationDuration: 1,
                                                                  result: loginResultFailure)
    
    // MARK: login()
    func login(login: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResponse>) -> Void) {
        if (login == fake.user.login) && (password == fake.user.password) {
            completionHandler(loginResponseSuccess)
        } else {
            completionHandler(loginResponseFailure)
        }
    }

    
    
    // MARK: LOGOUT
    let logoutResultSuccess: Result<LogoutResponse, AFError> = .success(LogoutResponse(result: 1, message: "success"))
    let logoutResultFailure: Result<LogoutResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var logoutResponseSuccess = AFDataResponse<LogoutResponse>(request: nil,
                                                                    response: nil,
                                                                    data: nil,
                                                                    metrics: nil,
                                                                    serializationDuration: 1,
                                                                    result: logoutResultSuccess)
    lazy var logoutResponseFailure = AFDataResponse<LogoutResponse>(request: nil,
                                                                    response: nil,
                                                                    data: nil,
                                                                    metrics: nil,
                                                                    serializationDuration: 1,
                                                                    result: logoutResultFailure)
    
    // MARK: logout()
    func logout(id: Int, token: String, completionHandler: @escaping (AFDataResponse<LogoutResponse>) -> Void) {
        if (id == fake.user.id) && (token == fake.token) {
            completionHandler(logoutResponseSuccess)
        } else {
            completionHandler(logoutResponseFailure)
        }
    }
}


// MARK: - MockNetworkUserRequest
//
class MockNetworkUserRequest: UserRequestFactory {
        
    let fake = FakeData()
    
    // MARK: REGISTER
    let userRegisterResponse = UserRegisterResponse(result: 1, message: "success", user: FakeData().user, token: FakeData().token)
    
    lazy var registerResultSuccess: Result<UserRegisterResponse, AFError> = .success(userRegisterResponse)
    lazy var registerResultFailure: Result<UserRegisterResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var registerResponseSuccess = AFDataResponse<UserRegisterResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultSuccess)
    lazy var registerResponseFailure = AFDataResponse<UserRegisterResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultFailure)
    // MARK: register()
    func register(user: User, completionHandler: @escaping (AFDataResponse<UserRegisterResponse>) -> Void) {
        if (user.firstName == fake.user.firstName) &&
           (user.lastName == fake.user.lastName) &&
           (user.gender == fake.user.gender) &&
           (user.email == fake.user.email) &&
           (user.creditCard == fake.user.creditCard) &&
           (user.login == fake.user.login) &&
           (user.password == fake.user.password) {
            completionHandler(registerResponseSuccess)
        } else {
            completionHandler(registerResponseFailure)
        }
    }
    
    // MARK: CHANGE
    let userDataChangeResponse = UserDataChangeResponse(result: 1, message: "success", user: FakeData().user)
    lazy var changeResultSuccess: Result<UserDataChangeResponse, AFError> = .success(userDataChangeResponse)
    lazy var changeResultFailure: Result<UserDataChangeResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var changeResponseSuccess = AFDataResponse<UserDataChangeResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultSuccess)
    lazy var changeResponseFailure = AFDataResponse<UserDataChangeResponse>(request: nil,
                                                                            response: nil,
                                                                            data: nil,
                                                                            metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultFailure)
    // MARK: change()
    func change(user: User, token: String, completionHandler: @escaping (AFDataResponse<UserDataChangeResponse>) -> Void) {
        if (user == fake.user) && (token == fake.token) {
            completionHandler(changeResponseSuccess)
        } else {
            completionHandler(changeResponseFailure)
        }
    }
}


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


// MARK: - MockCartRequestFactory
//
class MockCartRequestFactory: CartRequestFactory {
    
    let fake = FakeData()
    
    let cartResponse = CartResponse(result: 1, message: "success", cart: [FakeData().catalog[0].items[0]])
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
    
    func add(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if (productId == fake.product.id) && (owner == fake.user.id) && (token == fake.token) {
            completionHandler(cartResponseSuccess)
        } else {
            completionHandler(cartResponseFailure)
        }
    }
    
    func delete(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        return
    }
    
    func pay(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        return
    }
}


// MARK: - MockNetworkReviewRequest
//
class MockNetworkReviewRequest: ReviewRequestFactory {
    
    let reviewResponse = ReviewResponse(result: 1, message: "success", review: FakeData().reviewByProduct)
    lazy var reviewResultSuccess: Result<ReviewResponse, AFError> = .success(reviewResponse)
    lazy var reviewResultFailure: Result<ReviewResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var reviewResponseSuccess = AFDataResponse<ReviewResponse>(request: nil,
                                                                    response: nil,
                                                                    data: nil,
                                                                    metrics: nil,
                                                                    serializationDuration: 1,
                                                                    result: reviewResultSuccess)
    lazy var reviewResponseFailure = AFDataResponse<ReviewResponse>(request: nil,
                                                                    response: nil,
                                                                    data: nil,
                                                                    metrics: nil,
                                                                    serializationDuration: 1,
                                                                    result: reviewResultFailure)
    
    func reviewByProduct(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if id == 1 {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
    
    func reviewByUser(id: Int, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if id == 1 {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
    
    func reviewAdd(review: Review, token: String, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if token == FakeData().token {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
    
    func reviewDelete(reviewId: Int, userId: Int, token: String, completionHandler: @escaping (AFDataResponse<ReviewResponse>) -> Void) {
        if (token == FakeData().token) && (userId == FakeData().user.id) {
            completionHandler(reviewResponseSuccess)
        } else {
            completionHandler(reviewResponseFailure)
        }
    }
}
