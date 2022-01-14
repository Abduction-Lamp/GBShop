//
//  CartResponseCodableTests.swift
//  GBShopTests
//
//  Created by Владимир on 16.12.2021.
//

import XCTest
import Alamofire
@testable import GBShop

class CartResponseCodableTests: XCTestCase {
    var request: CartRequestFactory!
    var initialStateEexpectation: XCTestExpectation!
    var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        request = RequestFactory().makeCartRequestFactory()
        initialStateEexpectation = XCTestExpectation(description: "[ INITIAL STATE MOCK SERVER ]")
        expectation = XCTestExpectation(description: "[ Test ]")
        initialStateServer()
    }
    
    override func tearDownWithError() throws {
        request = nil
        initialStateEexpectation = nil
        expectation = nil
        try super.tearDownWithError()
    }
    
    // MARK: - SUPPORT: Сбрасывает мок-данные на сервере в исходное состояние
    private func initialStateServer() {
        AF.request("https://salty-springs-77873.herokuapp.com/mock/server/state/initial")
            .responseJSON { response in
                switch response.result {
                case .success(let jsonObject):
                    if let json = jsonObject as? [String: Any] {
                        print(String(describing: "\n - [ INITIAL STATE MOCK SERVER ]: \(json["message"] ?? "nil")"))
                    } else {
                        XCTFail("server has not returned to its initial state")
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                self.initialStateEexpectation.fulfill()
            }
        wait(for: [self.initialStateEexpectation], timeout: 5.0)
    }
    
    // MARK: - SUPPORT: Добовляет тавар в корзину
    private func addItemInCart(productId: Int, owner: Int, token: String) {
        let expectationAddToCart = XCTestExpectation(description: "[ ADD ITEM TO CART ]")
        request.addProduct(productId: productId, owner: owner, token: token) { response in
            switch response.result {
            case .success: break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectationAddToCart.fulfill()
        }
        wait(for: [expectationAddToCart], timeout: 10.0)
    }
}

// MARK: - TESTS CART
//
extension CartResponseCodableTests {
    
    // MARK: Пустая корзина
    func testCartEmptyResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1,
                                      message: "Корзина пустк",
                                      cart: nil)
    
        print(" - [TEST START]: testCartEmptyResponseSuccess()\n")
        request.cart(owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    // MARK: Корзина с двумя товарами
    //       - Добовляет 2 товара в корзину
    //       - Проверяет корзину
    func testCartResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1,
                                      message: "Количество товаров в казине: 2, на сумму: 340003",
                                      cart: [
                                        CartItem(product: Product(id: 1,
                                                                  name: "MacBook Pro",
                                                                  category: "Ноутбук",
                                                                  price: 250000,
                                                                  description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                                                                  imageURL: nil),
                                                 quantity: 1),
                                        CartItem(product: Product(id: 3,
                                                                  name: "PlayStation 5",
                                                                  category: "Игровая приставка",
                                                                  price: 90003,
                                                                  description: "825 ГБ SSD, белый",
                                                                  imageURL: nil),
                                                 quantity: 1)
                                      ])

        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        addItemInCart(productId: 3, owner: 2, token: tokenToId2)
        
        print(" - [TEST START]: testCartResponseSuccess()\n")
        request.cart(owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Запрос корзины с неверным Token или ID
    func testCartResponseFailureToken() throws {
        let tokenToId2 = "token"
        let expression = CartResponse(result: 0,
                                      message: "Токен устарел",
                                      cart: nil)
    
        print(" - [TEST START]: testCartResponseFailureToken()\n")
        request.cart(owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}

// MARK: - TESTS ADD TO CART
//
extension CartResponseCodableTests {
    
    // MARK: Добавление товара в корзину
    func testAddToCartResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1,
                                      message: "В карзину добавлен: MacBook Pro",
                                      cart: [
                                        CartItem(product: Product(id: 1,
                                                                  name: "MacBook Pro",
                                                                  category: "Ноутбук",
                                                                  price: 250000,
                                                                  description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                                                                  imageURL: nil),
                                                 quantity: 1)
                                      ])

        print(" - [TEST START]: testAddToCartResponseSuccess()\n")
        request.addProduct(productId: 1, owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }

    // MARK: Добавление товара в корзину с неверным Token или ID
    func testAddToCartResponseFailureToken() throws {
        let tokenToId2 = "token"
        let expression = CartResponse(result: 0,
                                      message: "Токен устарел",
                                      cart: nil)

        print(" - [TEST START]: testAddToCartResponseFailureToken()\n")
        request.addProduct(productId: 1, owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Добавление товара в корзину с неверным ID продукта
    func testAddToCartResponseFailureProductID() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 0,
                                      message: "Товар не надена",
                                      cart: nil)

        print(" - [TEST START]: testAddToCartResponseFailureProductID()\n")
        request.addProduct(productId: 15, owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}

// MARK: - TESTS DELETE FROM CART
//
extension CartResponseCodableTests {
    
    // MARK: Удаления товара из корзины
    //       - Добовляет 2 товара в корзину
    //       - Удаляет 1 товар
    func testDeleteFromeCartResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1,
                                      message: "Товар MacBook Pro удален из карзины",
                                      cart: [
                                        CartItem(product: Product(id: 3,
                                                                  name: "PlayStation 5",
                                                                  category: "Игровая приставка",
                                                                  price: 90003,
                                                                  description: "825 ГБ SSD, белый",
                                                                  imageURL: nil),
                                                 quantity: 1)
                                            ])

        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        addItemInCart(productId: 3, owner: 2, token: tokenToId2)

        print(" - [TEST START]: testDeleteFromeCartResponseSuccess()\n")
        request.deleteProduct(productId: 1, owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Удаляет товар из корзины с неверным Token или ID
    func testDeleteFromCartResponseFailureToken() throws {
        let tokenToId2 = "token"
        let expression = CartResponse(result: 0,
                                      message: "Токен устарел",
                                      cart: nil)

        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        
        print(" - [TEST START]: testDeleteFromCartResponseFailureToken()\n")
        request.deleteProduct(productId: 1, owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Удаляет товар из корзины с неверным ID товара
    func testDeleteFromCartResponseFailureProductID() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 0,
                                      message: "Товар не надена",
                                      cart: nil)

        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        
        print(" - [TEST START]: testDeleteFromCartResponseFailureProductID()\n")
        request.deleteProduct(productId: 15, owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Удаляет товар из пустой корзины
    func testDeleteFromEmptyCartResponseFailure() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 0,
                                      message: "Корзина пустк",
                                      cart: nil)
        
        print(" - [TEST START]: testDeleteFromEmptyCartResponseFailure()\n")
        request.deleteProduct(productId: 1, owner: 2, token: tokenToId2) { response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Удаления группы товаров из корзины
    //       - Добовляет 2 одинаковых товара в корзину
    //       - Удаляем целую группу
    func testDeleteAllByProductFromeCartResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1, message: "Товары PlayStation 5 удалены из карзины", cart: [])

        addItemInCart(productId: 3, owner: 2, token: tokenToId2)
        addItemInCart(productId: 3, owner: 2, token: tokenToId2)

        print(" - [TEST START]: testDeleteFromeCartResponseSuccess()\n")
        request.deleteAllByProduct(productId: 3, owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    func testDeleteAllFromeCartResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1, message: "Все товар удалены из карзины", cart: nil)

        addItemInCart(productId: 3, owner: 2, token: tokenToId2)
        addItemInCart(productId: 3, owner: 2, token: tokenToId2)
        addItemInCart(productId: 1, owner: 2, token: tokenToId2)

        print(" - [TEST START]: testDeleteFromeCartResponseSuccess()\n")
        request.deleteAll(owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
    
// MARK: - TESTS PAY
//
extension CartResponseCodableTests {
    
    // MARK: Покупка
    //       - Добовляет 1 товар в корзину
    //       - Совершает покупку всех товаров в корзине
    func testCartPayResponseSuccess() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 1,
                                      message: "Поздравляем! Вы совершили покупку на сумму 250000",
                                      cart: nil)

        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        
        print(" - [TEST START]: testCartPayResponseSuccess()\n")
        request.pay(owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Покупка с неверным Token или ID
    func testCartPayResponseFailureToken() throws {
        let tokenToId2 = "token"
        let expression = CartResponse(result: 0,
                                      message: "Токен устарел",
                                      cart: nil)

        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        
        print(" - [TEST START]: testCartPayResponseFailureToken()\n")
        request.pay(owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Покупка с пустой корзиной
    func testCartEmptyPayResponseFailure() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 0,
                                      message: "Корзина пустк",
                                      cart: nil)
        
        print(" - [TEST START]: testCartEmptyPayResponseSuccess()\n")
        request.pay(owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
    
    // MARK: Покупка при недастоющим баллансом на счету
    //       - Добовляет 3 товар в корзину
    //       - Совершает покупку всех товаров в корзине
    //       - Получает отказ в покупке из-за недастоющего балланса
    func testCartPayResponseFailureInsufficientFunds() throws {
        let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
        let expression = CartResponse(result: 0,
                                      message: "Недостаточно денег на сету. Баланс: 330000. К оплате: 409773",
                                      cart: [
                                        CartItem(product: Product(id: 1,
                                                                  name: "MacBook Pro",
                                                                  category: "Ноутбук",
                                                                  price: 250000,
                                                                  description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                                                                  imageURL: nil),
                                                 quantity: 1),
                                        CartItem(product: Product(id: 3,
                                                                  name: "PlayStation 5",
                                                                  category: "Игровая приставка",
                                                                  price: 90003,
                                                                  description: "825 ГБ SSD, белый",
                                                                  imageURL: nil),
                                                 quantity: 1),
                                        CartItem(product: Product(id: 5,
                                                                  name: "XBox Series X",
                                                                  category: "Игровая приставка",
                                                                  price: 69770,
                                                                  description: "1000 ГБ SSD, черный",
                                                                  imageURL: nil),
                                                 quantity: 1)
                                      ])
        
        addItemInCart(productId: 1, owner: 2, token: tokenToId2)
        addItemInCart(productId: 3, owner: 2, token: tokenToId2)
        addItemInCart(productId: 5, owner: 2, token: tokenToId2)
        
        print(" - [TEST START]: testCartPayResponseFailureInsufficientFunds()\n")
        request.pay(owner: 2, token: tokenToId2) {response in
            switch response.result {
            case .success(let cart):
                XCTAssertEqual(cart.result, expression.result)
                XCTAssertEqual(cart.message, expression.message)
                XCTAssertEqual(cart.cart, expression.cart)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [self.expectation], timeout: 10.0)
    }
}
