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
    func addProductToCart(index: Int)
    func removeProductFromCart(index: Int)
    func removeItemFromCart(index: Int)
    func removeAll()
    
    func buy()
    
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
    
//    private let reportExceptions = CrashlyticsReportExceptions()
//    private let analytics = AnalyticsLog()

    // MARK: Initialization
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
                        } else {
//                            self.reportExceptions.report(login: self.user.login, code: .nilDataResult, result: result)
                        }
                    } else {
//                        self.reportExceptions.report(login: self.user.login, code: .rejectionResult, result: result)
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
//                    self.reportExceptions.report(error: error.localizedDescription)
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
//            self.reportExceptions.report(code: .undefinedBehavior)
            let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
            view?.showErrorAlert(message: message)
            return
        }
        let productId = cart.items[index].product.id
        
        let request = network.makeCartRequestFactory()
        request.addProduct(productId: productId, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    if let newCart = result.cart {
                        self.cart.items = newCart
//                        self.analytics.addProductToCart(user: self.user,
//                                                        product: self.shoppingСartSearch(id: productId),
//                                                        cart: self.cart)
                        
                        DispatchQueue.main.async { self.view?.updataCart(index: index) }
                    } else {
//                        self.reportExceptions.report(productID: productId, cart: self.cart, code: .nilDataResult, result: result)
                        DispatchQueue.main.async {
                            let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
                            self.view?.showErrorAlert(message: message)
                        }
                    }
                } else {
//                    self.reportExceptions.report(productID: productId, cart: self.cart, code: .rejectionResult, result: result)
                    DispatchQueue.main.async { self.view?.showErrorAlert(message: result.message) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
//                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
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
//            self.reportExceptions.report(code: .undefinedBehavior)
            let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
            view?.showErrorAlert(message: message)
            return
        }
        let productId = cart.items[index].product.id
        
        let request = network.makeCartRequestFactory()
        request.deleteProduct(productId: productId, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    if let newCart = result.cart {
                        let product = self.shoppingСartSearch(id: productId)
                        self.cart.items = newCart
//                        self.analytics.removeProductFromCart(user: self.user, product: product, cart: self.cart)
                        
                        DispatchQueue.main.async { self.view?.updataCart(index: index) }
                    } else {
//                        self.reportExceptions.report(productID: productId, cart: self.cart, code: .nilDataResult, result: result)
                        DispatchQueue.main.async {
                            let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
                            self.view?.showErrorAlert(message: message)
                        }
                    }
                } else {
//                    self.reportExceptions.report(productID: productId, cart: self.cart, code: .rejectionResult, result: result)
                    DispatchQueue.main.async { self.view?.showErrorAlert(message: result.message) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
//                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
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
//            self.reportExceptions.report(code: .undefinedBehavior)
            let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
            view?.showErrorAlert(message: message)
            return
        }
        
        let request = network.makeCartRequestFactory()
        let productId = cart.items[index].product.id
        request.deleteAllByProduct(productId: productId, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    if let newCart = result.cart {
                        let product = self.shoppingСartSearch(id: productId)
                        self.cart.items = newCart
//                        self.analytics.removeProductFromCart(user: self.user, product: product, cart: self.cart)
                        
                        DispatchQueue.main.async { self.view?.updataCart() }
                    } else {
//                        self.reportExceptions.report(productID: productId, cart: self.cart, code: .nilDataResult, result: result)
                        DispatchQueue.main.async {
                            let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
                            self.view?.showErrorAlert(message: message)
                        }
                    }
                } else {
//                    self.reportExceptions.report(productID: productId, cart: self.cart, code: .rejectionResult, result: result)
                    DispatchQueue.main.async { self.view?.showErrorAlert(message: result.message) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
//                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
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
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    self.cart.items = []
//                    self.analytics.removeAllCart(user: self.user)
                    DispatchQueue.main.async { self.view?.updataCart() }
                } else {
//                    self.reportExceptions.report(login: self.user.login, code: .rejectionResult, result: result)
                    DispatchQueue.main.async {
                        let message = NSLocalizedString("CartView.Alert.SomethingWenWrong.Text", comment: "")
                        self.view?.showErrorAlert(message: message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
//                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
            }
        }
    }
    
    func buy() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.pay(owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
//                    self.analytics.buy(user: self.user, cart: self.cart)
                    self.cart.items = []
                    DispatchQueue.main.async {
                        self.view?.updataCart()
                        self.view?.showErrorAlert(message: result.message)
                    }
                } else {
//                    self.reportExceptions.report(login: self.user.login, code: .rejectionResult, result: result)
                    DispatchQueue.main.async { self.view?.showErrorAlert(message: result.message) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
//                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
            }
        }
    }
    
    func backTo() {
        router?.popToBackFromCartViewController(cart: cart)
    }
    
    private func shoppingСartSearch(id: Int) -> Product? {
        return cart.items.first { $0.product.id == id }?.product
    }
}

extension CartViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - CartViewPresenter (class):"
    }
}
