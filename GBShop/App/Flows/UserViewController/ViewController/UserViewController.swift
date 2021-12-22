//
//  UserViewController.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

final class UserViewController: UIViewController {
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
//    var presenret: RegistrationViewPresenterProtool?
    
    private var userView: UserView {
        guard let view = self.view as? UserView else {
            return UserView(frame: self.view.frame)
        }
        return view
    }

    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        
        configurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notifiction.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notifiction.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Support methods
    //
    private func configurationView() {
        self.view = RegistrationView(frame: self.view.frame)
        
        userView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        userView.firstNameTextField.delegate = self
        userView.lastNameTextField.delegate = self
//        userView.genderSegmentControl.delegate = self
        userView.emailTextField.delegate = self
        userView.passwordTextField.delegate = self
        
    }
    
    private func showAlert(message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extension RegistrationView Protocol
//
//extension UserViewController: RegistrationViewProtocol {
//
//    func showAlertRequestError(error: Error) {
//        showAlert(message: error.localizedDescription, title: "error")
//    }
//
//    func showAlertRegisterError(message: String) {
//        showAlert(message: message, title: "Ошибка")
//    }
//
//    func presentMainView() {
//        showAlert(message: "Ok")
//    }
//}

// MARK: - Extension Button Actions
////
//extension UserViewController {
//
//    @objc
//    func pressedRegistrationButton(_ sender: UIButton) {
//        guard let firstName = userView.firstNameTextField.text,
//              let lastName = userView.lastNameTextField.text,
//              let email = userView.emailTextField.text,
//              let creditCard = userView.creditCardTextField.text,
//              let login = userView.loginTextField.text,
//              let password = userView.passwordTextField.text else {
////                  showAlert(message: "Не все поля заполнены")
//                  return
//              }
//              let gender = registrationView.genderSegmentControl.selectedSegmentIndex
//
//        presenret?.makeUser(firstName: firstName, lastName: lastName, gender: gender,
//                            email: email, creditCard: creditCard, login: login, password: password)
//    }
//}

// MARK: - Extension Keyboard Actions
//
extension UserViewController {

    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = userView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        userView.scrollView.contentInset = contentInset
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        userView.scrollView.contentInset = contentInset
    }

    @objc
    func keyboardHide(_ sender: Any?) {
        userView.scrollView.endEditing(true)
    }
}

// MARK: - TextField Delegate
//
extension UserViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === userView.passwordTextField else { return true}
        guard let count = textField.text?.count else { return false }
        switch count {
        case 0, 1, 2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17: break
        case 3, 8, 13: textField.text?.append("-")
        default: return false
        }
        return true
    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField === registrationView.passwordTextField {
//            textField.placeholder = ""
//        }
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField === registrationView.passwordTextField {
//            textField.placeholder = "Пароль"
//        }
//    }
}
