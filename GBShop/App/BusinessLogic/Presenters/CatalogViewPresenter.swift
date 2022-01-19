//
//  CatalogViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 26.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol CatalogViewProtocol: AbstractViewController {
    func setCatalog()
    func updateCartIndicator(count: Int)
    
    var presenret: CatalogViewPresenterProtocol? { get set }
}

protocol CatalogViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol, view: CatalogViewProtocol, network: RequestFactoryProtocol, user: User, token: String)
    
    var catalog: [Section] { get set }
    
    func addToCart(productId: Int)
    
    func updateUserData(user: User, token: String)
    func updateCart(cart: Cart)
    
    func goToUserPageView()
    func goToCartView()
    func goToProductView(id: Int)
}

// MARK: - CatalogView Presenter
//
final class CatalogViewPresenter: CatalogViewPresenterProtocol {
    
    private var router: RouterProtocol?
    private weak var view: CatalogViewProtocol?
    private let network: RequestFactoryProtocol
    
    private var user: User
    private var token: String
    
    private var cart: Cart = Cart()
    
    var catalog: [Section] = []

    private let reportExceptions = CrashlyticsReportExceptions()
    private let analytics = AnalyticsLog()
    
    // MARK: Initialization
    required init(router: RouterProtocol, view: CatalogViewProtocol, network: RequestFactoryProtocol, user: User, token: String) {
        
        self.router = router
        self.view = view
        self.network = network
        
        self.user = user
        self.token = token
        
        fetchCatalog(page: 0)
        fetchCart()
    }
}

extension CatalogViewPresenter {
    
    private func catalogSearch(id: Int) -> Product? {
        var product: Product?
        for index in 0 ..< catalog.count {
            product = catalog[index].items.first(where: { $0.id == id })
            if product != nil { break }
        }
        return product
    }
    
    private func fetchCatalog(page: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeProductRequestFactory()
        request.getCatalog(page: page) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    if let productList = result.catalog {
                        self.catalog = productList
                        DispatchQueue.main.async { self.view?.setCatalog() }
                    } else { self.reportExceptions.report(page: page, code: .nilDataResult, result: result) }
                } else {
                    self.reportExceptions.report(page: page, code: .rejectionResult, result: result)
                    DispatchQueue.main.async { self.view?.showErrorAlert(message: result.message) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
            }
        }
    }
    
    private func fetchCart() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.cart(owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                
                if result.result == 1 {
                    if let newCart = result.cart {
                        self.cart.items = newCart
                        DispatchQueue.main.async { self.view?.updateCartIndicator(count: self.cart.totalCartCount) }
                    } else {
                        self.reportExceptions.report(login: self.user.login, code: .nilDataResult, result: result)
                        DispatchQueue.main.async { self.view?.updateCartIndicator(count: 0) }
                    }
                } else {
                    self.reportExceptions.report(login: self.user.login, code: .rejectionResult, result: result)
                    DispatchQueue.main.async { self.view?.updateCartIndicator(count: 0) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
            }
        }
    }
    
    public func addToCart(productId: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.addProduct(productId: productId, owner: user.id, token: token) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    if let newCart = result.cart {
                        self.cart.items = newCart
                        self.analytics.addProductToCart(user: self.user, product: self.catalogSearch(id: productId), cart: self.cart)
                        DispatchQueue.main.async { self.view?.updateCartIndicator(count: self.cart.totalCartCount) }
                    } else {
                        self.reportExceptions.report(productID: productId, cart: self.cart, code: .nilDataResult, result: result)
                        DispatchQueue.main.async { self.view?.showErrorAlert(message: "Карзина пуста") }
                    }
                } else {
                    self.reportExceptions.report(productID: productId, cart: self.cart, code: .nilDataResult, result: result)
                    DispatchQueue.main.async { self.view?.showErrorAlert(message: result.message) }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async { self.view?.showRequestErrorAlert(error: error) }
            }
        }
    }
    
    public func updateUserData(user: User, token: String) {
        self.user = user
        self.token = token
    }
    
    func updateCart(cart: Cart) {
        self.cart = cart
        view?.updateCartIndicator(count: cart.totalCartCount)
    }
    
    public func goToUserPageView() {
        router?.pushUserPageViewController(user: user, token: token)
    }
    
    public func goToProductView(id: Int) {
//        let productList = catalog.flatMap({ $0.items })
//        if let product = productList.first(where: { $0.id == id }) {
        if let product = catalogSearch(id: id) {
            router?.pushProductViewController(user: user, token: token, product: product, cart: cart)
        }
    }
    
    public func goToCartView() {
        router?.pushCartViewController(user: user, token: token, cart: cart)
    }
}

extension CatalogViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - CatalogViewPresenter (class):"
    }
}
