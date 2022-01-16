//
//  CartViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 08.01.2022.
//

import Foundation

protocol CartViewProtocol: AbstractViewController {
    func updataCart()
    func updataCart(index: Int)
}

protocol CartViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol,
         view: CartViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         cart: Cart)
    
    var cart: Cart { get set }
    
    func fetchCart()
    func removeProductFromCart(index: Int)
    func addProductToCart(index: Int)
    func removeItemFromCart(index: Int)
    func removeAll()
    
    func backTo()
}

// MARK: - CartView Presenter
//
final class CartViewPresenter: CartViewPresenterProtocol {

    private var router: RouterProtocol?
    private weak var view: CartViewProtocol?
    private let network: RequestFactoryProtocol
    
    private let user: User
    private let token: String
    
    var cart: Cart

    init(router: RouterProtocol,
         view: CartViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String,
         cart: Cart) {
        
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        
        self.cart = cart
    }
}

extension CartViewPresenter {
    
    func fetchCart() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.cart(owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let newCart = result.cart {
                            self.cart.items = newCart
                            self.view?.updataCart()
                        }
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func addProductToCart(index: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        guard (0 ..< cart.items.count).contains(index) else {
            logging("[\(self) (0 ..< cart.items.count).contains(index) = \((0 ..< cart.items.count).contains(index))]")
            view?.showErrorAlert(message: "Что-то пошло не так")
            return
        }
        let productId = cart.items[index].product.id
        
        let request = network.makeCartRequestFactory()
        request.addProduct(productId: productId, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let newCart = result.cart {
                            self.cart.items = newCart
                            self.view?.updataCart(index: index)
                        } else {
                            self.view?.showErrorAlert(message: "Что-то пошло не так")
                        }
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func removeProductFromCart(index: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }

        guard (0 ..< cart.items.count).contains(index) else {
            logging("[\(self) (0 ..< cart.items.count).contains(index) = \((0 ..< cart.items.count).contains(index))]")
            view?.showErrorAlert(message: "Что-то пошло не так")
            return
        }
        let productId = cart.items[index].product.id
        
        let request = network.makeCartRequestFactory()
        request.deleteProduct(productId: productId, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let newCart = result.cart {
                            self.cart.items = newCart
                            self.view?.updataCart(index: index)
                        } else {
                            self.view?.showErrorAlert(message: "Что-то пошло не так")
                        }
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func removeItemFromCart(index: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        guard (0 ..< cart.items.count).contains(index) else {
            logging("[\(self) index не входит в диапазон (0 - \(cart.items.count - 1)]")
            view?.showErrorAlert(message: "Не удалось удалить товар из карзины")
            return
        }
        
        let request = network.makeCartRequestFactory()
        request.deleteAllByProduct(productId: cart.items[index].product.id, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let newCart = result.cart {
                            self.cart.items = newCart
                            self.view?.updataCart()
                        } else {
                            self.view?.showErrorAlert(message: result.message)
                        }
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func removeAll() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.deleteAll(owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        self.cart.items = []
                        self.view?.updataCart()
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func backTo() {
        router?.popToBackFromCartViewController(cart: cart)
    }
}

extension CartViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - CartViewPresenter (class):"
    }
}
