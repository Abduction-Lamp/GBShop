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
    func popToRootViewController()
    func pushCatalogViewController(user: User, token: String)
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
              let userPageViewController = builder?.makeCatalogViewController(router: self, user: user, token: token) else {
                  return
              }
        
        logging("[\(self) navigation: pushCatalogViewController]")
        navigation.pushViewController(userPageViewController, animated: true)
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
