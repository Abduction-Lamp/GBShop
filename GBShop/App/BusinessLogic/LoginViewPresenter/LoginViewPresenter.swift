//
//  LoginViewPresenter.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import Foundation

// MARK: - Protools
//
protocol LoginViewProtocol: AnyObject {
}

protocol LoginViewPresenterProtool: AnyObject {
    init(view: LoginViewProtocol)
}

// MARK: - LoginView Presenter
//
class LoginViewPresenter: LoginViewPresenterProtool {
    weak var view: LoginViewProtocol?
    
    required init(view: LoginViewProtocol) {
        self.view = view
    }
}
