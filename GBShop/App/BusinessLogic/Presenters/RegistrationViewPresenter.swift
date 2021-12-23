//
//  RegistrationViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol RegistrationViewProtocol: AbstractViewController { }

protocol RegistrationViewPresenterProtool: AnyObject {
    init(router: RouterProtocol, view: RegistrationViewProtocol, network: UserRequestFactory)
    func registration(firstName: String, lastName: String, gender: Int, email: String, creditCard: String, login: String, password: String)
}

// MARK: - RegistrationView Presenter
//
class RegistrationViewPresenter: RegistrationViewPresenterProtool {
    private var router: RouterProtocol?
    weak var view: RegistrationViewProtocol?
    private let network: UserRequestFactory
    
    private var newUser: User?
    private var token: String?
    
    required init(router: RouterProtocol, view: RegistrationViewProtocol, network: UserRequestFactory) {
        self.router = router
        self.view = view
        self.network = network
    }
    
    func registration(firstName: String, lastName: String, gender: Int, email: String, creditCard: String, login: String, password: String) {
        newUser = makeUser(firstName: firstName,
                           lastName: lastName,
                           gender: gender,
                           email: email,
                           creditCard: creditCard,
                           login: login,
                           password: password)
        
        guard let user = newUser else { return }
        requestRegister(user: user, password: password)
    }
    
    private func makeUser(firstName: String,
                          lastName: String,
                          gender: Int,
                          email: String,
                          creditCard: String,
                          login: String,
                          password: String) -> User? {
        guard !firstName.isEmpty else {
            view?.showErrorAlert(message: "Поле Имя не заполнено")
            return nil
        }
        guard !lastName.isEmpty else {
            view?.showErrorAlert(message: "Поле Фамилия не заполнено")
            return nil
        }
        guard !email.isEmpty else {
            view?.showErrorAlert(message: "Поле E-mail не заполнено")
            return nil
        }
        guard !creditCard.isEmpty else {
            view?.showErrorAlert(message: "Поле Кредитная Карта не заполнено")
            return nil
        }
        guard !login.isEmpty else {
            view?.showErrorAlert(message: "Поле Логин не заполнено")
            return nil
        }
        guard !password.isEmpty else {
            view?.showErrorAlert(message: "Поле Пароль не заполнено")
            return nil
        }
        guard email.isValidEmail() else {
            view?.showErrorAlert(message: "Не верный формат E-mail")
            return nil
        }
        guard creditCard.isValidCreditCard() else {
            view?.showErrorAlert(message: "Не верный формат Кредитной Карты")
            return nil
        }
        return User(id: 3,
                    login: login,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    gender: gender == 0 ? "m" : "w",
                    creditCard: creditCard)
    }
    
    private func requestRegister(user: User, password: String) {
        network.register(user: user, password: password) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    if result.result == 1 {
                        self.router?.pushUserPageViewController(user: user, token: "")
                    } else {
                        self.view?.showErrorAlert(message: result.message)
                    }
                case .failure(let error):
                    self.view?.showRequestErrorAlert(error: error)
                }
            }
        }
    }
}
