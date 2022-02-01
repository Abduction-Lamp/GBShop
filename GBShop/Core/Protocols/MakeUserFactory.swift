//
//  MakeUserFactory.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import Foundation

protocol MakeUserFactory {
    func makeUser(view: AbstractViewController?,
                  id: Int,
                  firstName: String,
                  lastName: String,
                  gender: Int,
                  email: String,
                  creditCard: String,
                  login: String,
                  password: String) -> User?
}

extension MakeUserFactory {
    
    func makeUser(view: AbstractViewController?,
                  id: Int,
                  firstName: String,
                  lastName: String,
                  gender: Int,
                  email: String,
                  creditCard: String,
                  login: String,
                  password: String) -> User? {
        
        guard !firstName.isEmpty else {
            let message = NSLocalizedString("RegistrationView.Alert.EmptyFirstNameField", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard !lastName.isEmpty else {
            let message = NSLocalizedString("RegistrationView.Alert.EmptyLastNameField", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard !email.isEmpty else {
            let message = NSLocalizedString("RegistrationView.Alert.EmptyEmailField", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard !creditCard.isEmpty else {
            let message = NSLocalizedString("RegistrationView.Alert.EmptyCreditCardField", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard !login.isEmpty else {
            let message = NSLocalizedString("RegistrationView.Alert.EmptyLoginField", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard !password.isEmpty else {
            let message = NSLocalizedString("RegistrationView.Alert.EmptyPasswordField", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard password.count > 6 else {
            let message = NSLocalizedString("RegistrationView.Alert.ShortPassword", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard email.isValidEmail() else {
            let message = NSLocalizedString("RegistrationView.Alert.WrongEmailFormat", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }
        guard creditCard.isValidCreditCard() else {
            let message = NSLocalizedString("RegistrationView.Alert.WrongCreditCardFormat", comment: "")
            view?.showErrorAlert(message: message)
            return nil
        }

        return User(id: id,
                    firstName: firstName,
                    lastName: lastName,
                    gender: gender == 0 ? "m" : "w",
                    email: email,
                    creditCard: creditCard,
                    login: login,
                    password: password)
    }
}
