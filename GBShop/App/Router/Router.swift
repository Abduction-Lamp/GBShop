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
    func presentRegistrationViewController()
    func pushUserViewController(user: User, token: String)
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
        guard let navigation = self.navigation,
              let rootViewController = builder?.makeLoginViewController(router: self) else {
                  return
              }
        navigation.viewControllers = [rootViewController]
    }
    
    func presentRegistrationViewController() {
        guard let navigation = self.navigation,
              let registrationViewController = builder?.makeRegistrationViewController(router: self) else {
                  return
              }
        navigation.pushViewController(registrationViewController, animated: true)
    }
    
    func pushUserViewController(user: User, token: String) {
        guard let navigation = self.navigation,
              let userPageViewController = builder?.makeUserPageViewController(router: self, user: user, token: token) else {
                  return
              }
        navigation.pushViewController(userPageViewController, animated: true)
    }
    
    func popToRootViewController() {
        guard let navigation = self.navigation else { return }
        navigation.popToRootViewController(animated: true)
    }
}
