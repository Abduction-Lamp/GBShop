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
    func updateCart(cart: [Product])
    
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
    
    private var cart: [Product] = []
    
    var catalog: [Section] = []

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
    
    private func fetchCatalog(page: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeProductRequestFactory()
        request.getCatalog(page: page) { response in
        
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let productList = result.catalog {
                            self.catalog = productList
                            self.view?.setCatalog()
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
    
    private func fetchCart() {
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
                        if let cart = result.cart {
                            self.cart = cart
                            self.view?.updateCartIndicator(count: cart.count)
                        } else {
                            self.view?.updateCartIndicator(count: 0)
                        }
                    } else {
                        self.view?.updateCartIndicator(count: 0)
                    }
                case .failure(let error):
                    logging("[\(self) error: \(error.localizedDescription)]")
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    public func addToCart(productId: Int) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let request = network.makeCartRequestFactory()
        request.add(productId: productId, owner: user.id, token: token) { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    logging("[\(self) result message: \(result.message)]")
                    if result.result == 1 {
                        if let cart = result.cart {
                            self.cart = cart
                            self.view?.updateCartIndicator(count: self.cart.count)
                        } else {
                            self.view?.showErrorAlert(message: "Карзина пуста")
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
    
    public func updateUserData(user: User, token: String) {
        self.user = user
        self.token = token
    }
    
    func updateCart(cart: [Product]) {
        self.cart = cart
        view?.updateCartIndicator(count: cart.count)
    }
    
    public func goToUserPageView() {
        router?.pushUserPageViewController(user: user, token: token)
    }
    
    public func goToProductView(id: Int) {
        let productList = catalog.flatMap({ $0.items })
        if let product = productList.first(where: { $0.id == id }) {
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
