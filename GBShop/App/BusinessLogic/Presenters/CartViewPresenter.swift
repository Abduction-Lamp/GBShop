//
//  CartViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 08.01.2022.
//

import Foundation

protocol CartViewProtocol: AbstractViewController {
    func updataCart()
}

protocol CartViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol,
         view: CartViewProtocol,
         network: RequestFactoryProtocol,
         user: User,
         token: String)
    
    var cart: Cart { get set }
    
    func fetchCart()
    func removeFromCart(index: Int)
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

    init(router: RouterProtocol, view: CartViewProtocol, network: RequestFactoryProtocol, user: User, token: String) {
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        
        self.cart = Cart(owner: user.id)
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
                            self.cart.cart = newCart
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
    
    func removeFromCart(index: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard (0 ..< cart.cart.count).contains(index) else {
            logging("[\(self) index не входит в диапазон (0 - \(cart.cart.count - 1)]")
            view?.showErrorAlert(message: "Не удалось удалить товар из карзины")
            return
        }
        
        let request = network.makeCartRequestFactory()
        request.delete(productId: cart.cart[index].id, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        self.cart.cart.remove(at: index)
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
}

extension CartViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - CartViewPresenter (class):"
    }
}
