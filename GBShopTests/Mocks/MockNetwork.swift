//
//  MockNetwork.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

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
}

class MockNetworkAuthRequest: AuthRequestFactory {
    
    // MARK: LOGIN
    let loginResultSuccess: Result<LoginResponse, AFError> = .success(LoginResponse(result: 1, message: "success", user: nil, token: nil))
    let loginResultFailure: Result<LoginResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var loginResponseSuccess = AFDataResponse<LoginResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: loginResultSuccess)
    lazy var loginResponseFailure = AFDataResponse<LoginResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: loginResultFailure)
    
    // MARK: LOGOUT
    let logoutResultSuccess: Result<LogoutResponse, AFError> = .success(LogoutResponse(result: 1, message: "success"))
    let logoutResultFailure: Result<LogoutResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var logoutResponseSuccess = AFDataResponse<LogoutResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: logoutResultSuccess)
    lazy var logoutResponseFailure = AFDataResponse<LogoutResponse>(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 1,
                                                             result: logoutResultFailure)
    
    // MARK: -
    //
    func login(login: String, password: String, completionHandler: @escaping (AFDataResponse<LoginResponse>) -> Void) {
        if (login == "login") && (password == "password") {
            completionHandler(loginResponseSuccess)
        } else {
            completionHandler(loginResponseFailure)
        }
    }
    
    func logout(id: Int, token: String, completionHandler: @escaping (AFDataResponse<LogoutResponse>) -> Void) {
        if (id == 3) && (token == "") {
            completionHandler(logoutResponseSuccess)
        } else {
            completionHandler(logoutResponseFailure)
        }
    }
}

// MARK: -
//
//
//
class MockNetworkUserRequest: UserRequestFactory {
    
    static var fakeUser: User = User(id: 3,
                                     firstName: "firstName",
                                     lastName: "lastName",
                                     gender: "m",
                                     email: "email@email.ru",
                                     creditCard: "1111-1111-1111-1111",
                                     login: "login",
                                     password: "password")
    
    // MARK: register
    lazy var registerResultSuccess: Result<UserRegisterResponse, AFError> = .success(UserRegisterResponse(result: 1,
                                                                                                          message: "success",
                                                                                                          user: MockNetworkUserRequest.fakeUser,
                                                                                                          token: "token"))
    lazy var registerResultFailure: Result<UserRegisterResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var registerResponseSuccess = AFDataResponse<UserRegisterResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultSuccess)
    lazy var registerResponseFailure = AFDataResponse<UserRegisterResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: registerResultFailure)
    
    // MARK: change
    lazy var changeResultSuccess: Result<UserDataChangeResponse, AFError> = .success(UserDataChangeResponse(result: 1,
                                                                                                            message: "success",
                                                                                                            user: MockNetworkUserRequest.fakeUser))
    lazy var changeResultFailure: Result<UserDataChangeResponse, AFError> = .failure(.explicitlyCancelled)
    
    lazy var changeResponseSuccess = AFDataResponse<UserDataChangeResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultSuccess)
    lazy var changeResponseFailure = AFDataResponse<UserDataChangeResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                            serializationDuration: 1,
                                                                            result: changeResultFailure)
    
    // MARK: -
    //
    func register(user: User, completionHandler: @escaping (AFDataResponse<UserRegisterResponse>) -> Void) {
        if  (user.firstName == MockNetworkUserRequest.fakeUser.firstName) &&
            (user.lastName == MockNetworkUserRequest.fakeUser.lastName) &&
            (user.gender == MockNetworkUserRequest.fakeUser.gender) &&
            (user.email == MockNetworkUserRequest.fakeUser.email) &&
            (user.creditCard == MockNetworkUserRequest.fakeUser.creditCard) &&
            (user.login == MockNetworkUserRequest.fakeUser.login) &&
            (user.password == MockNetworkUserRequest.fakeUser.password) {
            completionHandler(registerResponseSuccess)
        } else {
            completionHandler(registerResponseFailure)
        }
    }
    
    func change(user: User, token: String, completionHandler: @escaping (AFDataResponse<UserDataChangeResponse>) -> Void) {
        if (user == MockNetworkUserRequest.fakeUser) && (token == "") {
            completionHandler(changeResponseSuccess)
        } else {
            completionHandler(changeResponseFailure)
        }
    }
}

class MockProductRequest: ProductRequestFactory {
    
    static let catalog: [Section] = [
        
        Section(id: 1, title: "Ноутбук", items: [
            Product(id: 1,
                    name: "MacBook Pro",
                    category: "Ноутбук",
                    price: 250_000,
                    description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                    imageURL: nil),
            Product(id: 2,
                    name: "Microsoft Surface Laptop",
                    category: "Ноутбук",
                    price: 130_000,
                    description: "Экран 13.5 дюймов, Core i5, 8GB, SSD‑накопитель 512GB",
                    imageURL: nil)
        ]),
        
        Section(id: 2, title: "Игровая приставка", items: [
            Product(id: 3,
                    name: "PlayStation 5",
                    category: "Игровая приставка",
                    price: 90_003,
                    description: "825 ГБ SSD, белый",
                    imageURL: nil),
            Product(id: 4,
                    name: "PlayStation 4 Slim",
                    category: "Игровая приставка",
                    price: 44_500,
                    description: "500 ГБ HDD, черный",
                    imageURL: nil),
            Product(id: 5,
                    name: "XBox Series X",
                    category: "Игровая приставка",
                    price: 69_770,
                    description: "1000 ГБ SSD, черный",
                    imageURL: nil)
        ])
    ]
    
    // MARK: Catalog
    lazy var catalogResultSuccess: Result<CatalogResponse, AFError> = .success(CatalogResponse(result: 1, message: "success",
                                                                                               catalog: MockProductRequest.catalog))
    lazy var catalogResultFailure: Result<CatalogResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var catalogResponseSuccess = AFDataResponse<CatalogResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: catalogResultSuccess)
    lazy var catalogResponseFailure = AFDataResponse<CatalogResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: catalogResultFailure)
    
    // MARK: Section
    lazy var sectionResultSuccess: Result<SectionResponse, AFError> = .success(SectionResponse(result: 1, message: "success",
                                                                                               section: MockProductRequest.catalog[0]))
    lazy var sectionResultFailure: Result<SectionResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var sectionResponseSuccess = AFDataResponse<SectionResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: sectionResultSuccess)
    lazy var sectionResponseFailure = AFDataResponse<SectionResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: sectionResultFailure)
    // MARK: Product
    lazy var productResultSuccess: Result<ProductResponse, AFError> = .success(ProductResponse(result: 1, message: "success",
                                                                                               product: MockProductRequest.catalog[0].items[0]))
    lazy var productResultFailure: Result<ProductResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var productResponseSuccess = AFDataResponse<ProductResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: productResultSuccess)
    lazy var productResponseFailure = AFDataResponse<ProductResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: productResultFailure)
    
    func getCatalog(page: Int, completionHandler: @escaping (AFDataResponse<CatalogResponse>) -> Void) {
        if page >= 0 {
            completionHandler(catalogResponseSuccess)
        } else {
            completionHandler(catalogResponseFailure)
        }
    }
    
    func getSection(id: Int, page: Int, completionHandler: @escaping (AFDataResponse<SectionResponse>) -> Void) {
        if id == 0 {
            completionHandler(sectionResponseSuccess)
        } else {
            completionHandler(sectionResponseFailure)
        }
    }
    
    func getProduct(id: Int, completionHandler: @escaping (AFDataResponse<ProductResponse>) -> Void) {
        if id == 0 {
            completionHandler(productResponseSuccess)
        } else {
            completionHandler(productResponseFailure)
        }
    }
}

class MockCartRequestFactory: CartRequestFactory {
    
    // MARK: Catalog
    lazy var cartResultSuccess: Result<CartResponse, AFError> = .success(CartResponse(result: 1,
                                                                                      message: "success",
                                                                                      cart: [
                                                                                        Product(id: 1,
                                                                                                name: "MacBook Pro",
                                                                                                category: "Ноутбук",
                                                                                                price: 250_000,
                                                                                                description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                                                                                                imageURL: nil)
                                                                                      ]))
    lazy var cartResultFailure: Result<CartResponse, AFError> = .failure(.explicitlyCancelled)
          
    lazy var cartResponseSuccess = AFDataResponse<CartResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: cartResultSuccess)
    lazy var cartResponseFailure = AFDataResponse<CartResponse>(request: nil, response: nil, data: nil, metrics: nil,
                                                                      serializationDuration: 1,
                                                                      result: cartResultFailure)
    
    func cart(owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        return
    }
    
    func add(productId: Int, owner: Int, token: String, completionHandler: @escaping (AFDataResponse<CartResponse>) -> Void) {
        if productId > 0 || owner == 0 {
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
