//
//  LoginViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import Foundation
import Firebase

// MARK: - Protools
//
protocol LoginViewProtocol: AbstractViewController {
    func showLoadingScreen()
    func hideLoadingScreen()
}

protocol LoginViewPresenterProtocol: AnyObject {
    init(router: RouterProtocol, view: LoginViewProtocol, network: AuthRequestFactory)
    
    func auth(login: String, password: String)
    func goToRegistrationView()
}

// MARK: - LoginView Presenter
//
final class LoginViewPresenter: LoginViewPresenterProtocol {
    
    private var router: RouterProtocol?
    private weak var view: LoginViewProtocol?
    private let network: AuthRequestFactory

    private let reportExceptions = CrashlyticsReportExceptions()
    private let analytics = AnalyticsLog()
    
    required init(router: RouterProtocol, view: LoginViewProtocol, network: AuthRequestFactory) {
        self.router = router
        self.view = view
        self.network = network
    }
    
    func auth(login: String, password: String) {
        logging(.funcStart)
        defer {
            logging(.funcEnd)
        }

        self.view?.showLoadingScreen()
        
        network.login(login: login, password: password) { [weak self] response in
            guard let self = self else { return }
            logging("[\(self) login: \(login), password: \(password)]")
            
            switch response.result {
            case .success(let result):
                logging("[\(self) result message: \(result.message)]")
                if result.result == 1 {
                    guard let user = result.user,
                          let token = result.token else {
                              self.reportExceptions.report(login: login, code: .nilDataResult, result: result)
                              DispatchQueue.main.async {
                                  self.view?.hideLoadingScreen()
                                  self.view?.showErrorAlert(message: result.message)
                              }
                              return
                          }
                    Crashlytics.crashlytics().setUserID("\(user.id)")
                    Analytics.setUserID("\(user.id)")
                    self.analytics.login(user: user)
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.router?.pushCatalogViewController(user: user, token: token)
                    }
                } else {
                    self.reportExceptions.report(login: login, code: .rejectionResult, result: result)
                    DispatchQueue.main.async {
                        self.view?.hideLoadingScreen()
                        self.view?.showErrorAlert(message: result.message)
                    }
                }
            case .failure(let error):
                logging("[\(self) error: \(error.localizedDescription)]")
                self.reportExceptions.report(error: error.localizedDescription)
                DispatchQueue.main.async {
                    self.view?.hideLoadingScreen()
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
    
    func goToRegistrationView() {
        router?.pushRegistrationViewController()
    }
}

extension LoginViewPresenter: CustomStringConvertible {
    
    var description: String {
        " - LoginViewPresenter (class):"
    }
}
