//
//  Router.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

// MARK: - Protocol
//
protocol AbstractRouterProtocol {
    var navigation: UINavigationController? { get set }
    var builder: BuilderProtocol? { get set }
}

protocol RouterProtocol: AbstractRouterProtocol {
    func initialViewController()
    func pushRegistrationViewController()
    func pushUserPageViewController(user: User, token: String)
    func pushCatalogViewController(user: User, token: String)
    func popToCatalogViewController(user: User, token: String)
    func pushProductViewController(user: User, token: String, product: Product)
    
    func popToRootViewController()
}

// MARK: - Router
//
class Router: RouterProtocol {
    var navigation: UINavigationController?
    var builder: BuilderProtocol?
    
    init(navigation: UINavigationController, builder: BuilderProtocol) {
        self.navigation = navigation
        self.builder = builder
    }
    
    func initialViewController() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation,
              let rootViewController = builder?.makeLoginViewController(router: self) else {
                  return
              }
        
        logging("[\(self) initial navigation]")
        navigation.viewControllers = [rootViewController]
    }
    
    func pushRegistrationViewController() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation,
              let registrationViewController = builder?.makeRegistrationViewController(router: self) else {
                  return
              }
        
        logging("[\(self) navigation: pushRegistrationViewController]")
        navigation.pushViewController(registrationViewController, animated: true)
    }
    
    func pushUserPageViewController(user: User, token: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation,
              let userPageViewController = builder?.makeUserPageViewController(router: self, user: user, token: token) else {
                  return
              }
        
        logging("[\(self) navigation: pushUserPageViewController]")
        navigation.pushViewController(userPageViewController, animated: true)
    }
    
    func pushCatalogViewController(user: User, token: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation,
              let catalogViewController = builder?.makeCatalogViewController(router: self, user: user, token: token) else {
                  return
              }
        
        logging("[\(self) navigation: pushCatalogViewController]")
        navigation.pushViewController(catalogViewController, animated: true)
    }
    
    func popToCatalogViewController(user: User, token: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation else { return }
        let catalogViewController = navigation.viewControllers.first(where: { $0 is CatalogViewProtocol })
        if let controller = catalogViewController as? CatalogViewController {
            logging("[\(self) navigation: popToCatalogViewController]")
            navigation.popToViewController(controller, animated: true)
            controller.updateUserDataInPresenter(user: user, token: token)
        } else {
            logging("[\(self) navigation: popToRootViewController]")
            navigation.popToRootViewController(animated: true)
        }
    }
    
    func pushProductViewController(user: User, token: String, product: Product) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation,
              let productViewController = builder?.makeProductViewController(router: self, user: user, token: token, product: product) else {
                  return
              }
        
        logging("[\(self) navigation: pushProductViewController]")
        navigation.pushViewController(productViewController, animated: true)
    }
    
    func popToRootViewController() {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        guard let navigation = self.navigation else { return }
        
        logging("[\(self) navigation: popToRootViewController]")
        navigation.popToRootViewController(animated: true)
    }
}

extension Router: CustomStringConvertible {
    
    var description: String {
        " - Router (class):"
    }
}
