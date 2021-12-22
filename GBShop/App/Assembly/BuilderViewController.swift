//
//  BuilderViewController.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import UIKit

protocol BuilderProtocol: AnyObject {
    func makeLoginViewController(router: RouterProtocol) -> UIViewController & LoginViewProtocol
    func makeRegistrationViewController(router: RouterProtocol) -> UIViewController & RegistrationViewProtocol
    func makeUserPageViewController(router: RouterProtocol, user: User, token: String) -> UIViewController
}

class BuilderViewController: BuilderProtocol {
    func makeLoginViewController(router: RouterProtocol) -> UIViewController & LoginViewProtocol {
        let viewController = LoginViewController()
        let network = RequestFactory().makeAuthRequestFatory()
        let presenter = LoginViewPresenter(router: router, view: viewController, network: network)
        viewController.presenret = presenter
        return viewController
    }
    
    func makeRegistrationViewController(router: RouterProtocol) -> UIViewController & RegistrationViewProtocol {
        let viewController = RegistrationViewController()
        let network = RequestFactory().makeUserRequestFactory()
        let presenter = RegistrationViewPresenter(router: router, view: viewController, network: network)
        viewController.presenret = presenter
        return viewController
    }
    
    func makeUserPageViewController(router: RouterProtocol, user: User, token: String) -> UIViewController {
        let viewController = UserPageViewController()
        let network = RequestFactory()
        let presenter = UserPageViewPresenter(router: router, view: viewController, network: network, user: user, token: token)
        viewController.presenret = presenter
        return viewController
    }
}
