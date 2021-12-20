//
//  BuilderViewController.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import UIKit

protocol Builder: AnyObject {
    static func makeLoginViewController() -> UIViewController
}

class BuilderViewController: Builder {
    static func makeLoginViewController() -> UIViewController {
        let viewController = LoginViewController()
        let presenter = LoginViewPresenter(view: viewController)
        viewController.presenret = presenter
        return viewController
    }
}
