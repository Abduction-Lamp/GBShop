//
//  RegistrationViewController.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    var presenret: RegistrationViewPresenterProtool?
    
    private var registrationView: RegistrationView {
        guard let view = self.view as? RegistrationView else {
            return RegistrationView(frame: self.view.frame)
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
        
        registrationView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        registrationView.firstNameTextField.delegate = self
        registrationView.lastNameTextField.delegate = self
//        registrationView.genderSegmentControl.delegate = self
        registrationView.emailTextField.delegate = self
        registrationView.passwordTextField.delegate = self
        
        registrationView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
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
extension RegistrationViewController: RegistrationViewProtocol {
    
    func showAlertRequestError(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showAlertRegisterError(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
    
    func presentMainView() {
        showAlert(message: "Ok")
    }
}

// MARK: - Extension Button Actions
//
extension RegistrationViewController {
    
    @objc
    func pressedRegistrationButton(_ sender: UIButton) {
        guard let firstName = registrationView.firstNameTextField.text,
              let lastName = registrationView.lastNameTextField.text,
              let email = registrationView.emailTextField.text,
              let creditCard = registrationView.creditCardTextField.text,
              let login = registrationView.loginTextField.text,
              let password = registrationView.passwordTextField.text else {
                  showAlert(message: "Не все поля заполнены")
                  return
              }
              let gender = registrationView.genderSegmentControl.selectedSegmentIndex
        
        presenret?.makeUser(firstName: firstName,
                            lastName: lastName,
                            gender: gender,
                            email: email,
                            creditCard: creditCard,
                            login: login,
                            password: password)
    }
}

// MARK: - Extension Keyboard Actions
//
extension RegistrationViewController {

    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = registrationView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        registrationView.scrollView.contentInset = contentInset
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        registrationView.scrollView.contentInset = contentInset
    }

    @objc
    func keyboardHide(_ sender: Any?) {
        registrationView.scrollView.endEditing(true)
    }
}

// MARK: - TextField Delegate
//
extension RegistrationViewController: UITextFieldDelegate {
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
