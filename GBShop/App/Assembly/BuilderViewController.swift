//
//  BuilderViewController.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import UIKit

protocol Builder: AnyObject {
    static func makeLoginViewController() -> UIViewController & LoginViewProtocol
    static func makeRegistrationViewController() -> UIViewController & RegistrationViewProtocol
}

class BuilderViewController: Builder {
    static func makeLoginViewController() -> UIViewController & LoginViewProtocol {
        let viewController = LoginViewController()
        let request = RequestFactory()
        let presenter = LoginViewPresenter(view: viewController, network: request.makeAuthRequestFatory())
        viewController.presenret = presenter
        return viewController
    }
    
    static func makeRegistrationViewController() -> UIViewController & RegistrationViewProtocol {
        let viewController = RegistrationViewController()
        let request = RequestFactory()
        let presenter = RegistrationViewPresenter(view: viewController, network: request.makeUserRequestFactory())
        viewController.presenret = presenter
        return viewController
    }
}
