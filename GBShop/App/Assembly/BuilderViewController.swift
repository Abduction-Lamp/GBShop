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
    func makeUserPageViewController(router: RouterProtocol, user: User, token: String) -> UIViewController & UserPageViewProtocol
    func makeCatalogViewController(router: RouterProtocol, user: User, token: String) -> UICollectionViewController & CatalogViewProtocol
}

class BuilderViewController: BuilderProtocol {
    
    func makeLoginViewController(router: RouterProtocol) -> UIViewController & LoginViewProtocol {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let viewController = LoginViewController()
        let network = RequestFactory().makeAuthRequestFactory()
        let presenter = LoginViewPresenter(router: router, view: viewController, network: network)
        viewController.presenret = presenter
        
        logging("[\(self) MAKE LoginView Module]")
        return viewController
    }
    
    func makeRegistrationViewController(router: RouterProtocol) -> UIViewController & RegistrationViewProtocol {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let viewController = RegistrationViewController()
        let network = RequestFactory().makeUserRequestFactory()
        let presenter = RegistrationViewPresenter(router: router, view: viewController, network: network)
        viewController.presenret = presenter
        
        logging("[\(self) MAKE RegistrationView Module]")
        return viewController
    }
    
    func makeUserPageViewController(router: RouterProtocol, user: User, token: String) -> UIViewController & UserPageViewProtocol {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let viewController = UserPageViewController()
        let network = RequestFactory()
        let presenter = UserPageViewPresenter(router: router, view: viewController, network: network, user: user, token: token)
        viewController.presenret = presenter
        
        logging("[\(self) MAKE UserPageView Module]")
        return viewController
    }
    
    func makeCatalogViewController(router: RouterProtocol, user: User, token: String) -> UICollectionViewController & CatalogViewProtocol {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }
        
        let layout = UICollectionViewFlowLayout()
        let viewController = CatalogViewController(collectionViewLayout: layout)
        let network = RequestFactory().makeProductRequestFactory()
        let presenter = CatalogViewPresenter(router: router, view: viewController, network: network, user: user, token: token)
        viewController.presenret = presenter
        
        logging("[\(self) MAKE CatalogView Module]")
        return viewController
    }
}

extension BuilderViewController: CustomStringConvertible {
    
    var description: String {
        " - [Assembly] BuilderViewController (class):"
    }
}
